var fs = require('fs');
var https = require('https');
var validator = require('is-my-json-valid');

fs.readFile('killbill.json', 'utf8', function (err, input) {
    https.get('https://schema.getpostman.com/json/collection/v1/', function (response) {
        var body = '';

        response.on('data', function (d) {
            body += d;
        });

        response.on('end', function () {
            var validate = validator(JSON.parse(body));
            console.log(validate(input) ? 'It is valid!' : 'It is invalid!');
            console.log('The errors were:', validate.errors)
        });
    });
});
