const AWS = require('aws-sdk');
const App = require('express')();
const Cors = require('cors');
const Config = require('./config');

App.use(Cors())

AWS.config.update({
    region: Config.REGION,
});

var docClient = new AWS.DynamoDB.DocumentClient();

var params = {
    TableName: Config.TABLE,
};

App.get('/movies', (req, res) => {
    docClient.scan(params, (err, data) => {
        if (err) {
            res.status(500).send('Something went wrong');
            throw err
        } else {
            console.log("Number of movies:", data.Items.length)
            res.send(data.Items)
        }
    });
})

App.listen(Config.PORT, () => {
    console.log('Server listening on port', Config.PORT)
})
