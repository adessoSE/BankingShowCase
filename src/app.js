const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bankingshowcase'
});

db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('Database Connected...');
});

const app = express();
// Add headers
app.use(function (req, res, next) {


    res.setHeader('Access-Control-Allow-Origin', '*', 'http://localhost:8100', 'http://localhost:8101', 'http://localhost:8000/*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    res.setHeader('Access-Control-Allow-Headers', '*');

    res.setHeader('Access-Control-Allow-Credentials', true);

    next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));

app.post('/payment-data', (req, res) => {
    console.log("Post request on /payment-data");
    console.log(req.body);
    let sql = "INSERT INTO `payment_data` (`step`, `action`, `amount`, `amount_real`, `nameOrig`, `place`, `date`, `datetime`, `verwendungszweck`, `oldBalanceOrig`, `newBalanceOrig`, `nameDest`, `oldBalanceDest`, `newBalanceDest`, `isFraud`, `isFlaggedFraud`, `isUnauthorizedOverdraft`, `timestamp`) VALUES ('"+req.body.payment_data.step+"', '"+req.body.payment_data.action+"', '"+req.body.payment_data.amount+"', '"+req.body.payment_data.amount_real+"', '"+req.body.payment_data.nameOrig+"', '"+req.body.payment_data.place+"', '"+req.body.payment_data.date+"', '"+req.body.payment_data.datetime+"', '"+req.body.payment_data.verwendungszweck+"', '"+req.body.payment_data.oldBalanceOrig+"', '"+req.body.payment_data.newBalanceOrig+"', '"+req.body.payment_data.nameDest+"', '"+req.body.payment_data.oldBalanceDest+"', '"+req.body.payment_data.newBalanceDest+"', '"+req.body.payment_data.isFraud+"', '"+req.body.payment_data.isFlaggedFraud+"', '"+req.body.payment_data.isUnauthorizedOverdraft+"', '"+req.body.payment_data.datetime_timestamp+"');"
    console.log("Fire SQL Query...");
    console.log("Query: "+ sql);
    db.query(sql,(err, result) => {
        if(err){
            console.log("Sql Query err: " +err);
            res.status(500).send({error: {message: "Error: Payment Daten nicht abgespeichert."}})
        }
        console.log("Payment Daten erfolgreich abgespeichert.");
        res.status(200).send({data: {message: "Payment Daten erfolgreich abgespeichert." , error: 0} });
    });
})

app.listen('3000', () => {
    console.log('Server started on port 3000.');
});