<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String pageTitle = "Sondmatning v 1.39"; %>
<!DOCTYPE html>
<html>
<head>
	<title><%= pageTitle %></title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.css" />
    <style>
        h3 { text-align: center; }
        #headerLink {
            color: #FFF;
            text-decoration:none;
        }
        .timerContent, #timerList li {
            text-align: center;
        }
        #timerList .smaller {
            font-weight: normal;
            font-size: 0.8em;
        }
        #timerList .timerListItem {
            padding: 0;
        }
        #timer {
            font-size: 8em;
        }
    </style>
	<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.js"></script>
    <script type="text/javascript">
        $(function() {
            // String.format
            // "{0} is dead, but {1} is alive! {0} {2}".format("ASP", "ASP.NET")
            if (!String.prototype.format) {
              String.prototype.format = function() {
                var args = arguments;
                return this.replace(/{(\d+)}/g, function(match, number) {
                      return typeof args[number] != 'undefined'
                    ? args[number]
                    : match
                  ;
                });
              };
            }

            // Zero pads given number with one zero. 1 --> 01
            var pad = function(number) {
                var str = "" + number;
                var pad = "00";
                return pad.substring(0, pad.length - str.length) + str;
            };

            var ONE_SECOND = 1000;
            var ONE_MINUTE = 60 * ONE_SECOND;

            var playSound = function() {
                document.getElementById('audiotag').play();
            };

            $('#startButton').click(function() {
                // Calculate speed
                var amount = parseInt($('#amount').val());
                var time = parseInt($('#time').val());
                var speed = parseInt($('#speed').val());
                var totalTime = time * 60;
                var interval = totalTime / (amount / speed);

                // Print results
                var result = 'Du vill mata {0} ml på {1} minuter.'.format(amount, time);
                result += '<br>{0} ml varje {1} sekunder.<br>'.format(speed, interval);
                $('#result').html(result);

                var counter = interval;
                var total = speed;
                $('#timer').html(pad(counter));
                var percent = (total / amount) * 100;
                $('#total').html("{0} ml ({1}%)".format(total, Math.floor(percent)));

                setInterval(function() {
                    counter--;
                    $('#timer').html(pad(counter));
                    // Check if time to feed
                    if (counter == 0) {
                        playSound();
                        
                        // Reset counter
                        counter = interval;
                        total = total + speed;
                        var percent = (total / amount) * 100 ;
                        $('#total').html("{0} ml ({1}%)".format(total, Math.floor(percent)));
                }
                }, 1000);
            });
        });
    </script>
</head>
<body>

<div data-role="page" data-theme="b">
	<div data-role="header">
        <div>
            <h3><%= pageTitle %></h3>
        </div>
	</div>
	<div data-role="content">
        <label for="amount">Ange mängd (ml):</label>
        <input type="text" name="amount" id="amount" value="50" />
        <label for="time">Ange tid (minuter):</label>
        <input type="text" name="time" id="time" value="30" />
        <label for="speed">Ange mängd per tryck (ml):</label>
        <input type="text" name="time" id="speed" value="2" />
        <br />
        Börja mata och tryck på knappen!
        <a href="#start" id="startButton" data-role="button">Starta</a>
	</div>
	<div data-role="footer" data-position="fixed">
		<h4>&nbsp;</h4>
	</div>
</div>

<div data-role="page" id="start">
	<div data-role="header">
        <div>
            <h3><a id="headerLink" href="/" data-ajax="false"><%= pageTitle %></a></h3>
        </div>
	</div>
	<div class="timerContent" data-role="content">
        <span id="result"></span>
        <br>
        <br>
        <br>
        <ul data-role="listview" id="timerList">
            <li data-role="list-divider" role="heading">Nästa matning om</li>
            <li class="timerListItem"><strong><span id="timer"></span></strong></li>
            <li class="smaller">Färdigt <span id="total"></span></li>
        </ul>
	</div>
	<div data-role="footer" data-position="fixed">
		<h4>&nbsp;</h4>
	</div>

    <audio id="audiotag" src="flute_c_long_01.wav" preload="auto"></audio>
</div>

</body>
</html>