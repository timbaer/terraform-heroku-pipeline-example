var port = process.env.PORT || 8080;
var express = require('express');
var app = express();
app.get('/', function (req, res) {
  res.send('<html><head></head><body><marquee direction="right" style="width:100%;height: 100%;color: deeppink;font-size: 5em;text-align: center;">Hello AS Ideas!</marquee></body>');
});
app.listen(port, function () {
  console.log('Example app listening on port ' + port);
});
