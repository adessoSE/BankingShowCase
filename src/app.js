const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const db = mysql.createConnection({
    host: '192.168.2.102',
    user: 'root',
    password: '',
    database: 'haushaltsbuch',
    debug: false
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
    let sqlUserInfo = "SELECT `transactionId`, `place`, `newBalanceOrig` FROM payment_data WHERE `nameOrig` = ?;";
    console.log("Fire SQL Query...");
    console.log("Query: "+ sqlUserInfo);
    db.query(sqlUserInfo, [req.body.payment_data.nameOrig], function(err, result){
        if(err){
            console.log("Sql Query err: " +err);
            res.status(500).send({error: {message: "Error: Userinformationsabfrage nicht erfolgreich."}})
        }        
        let transactionsIds = result.map(row => row['transactionId']);
        let indexOfMaximum = transactionsIds.indexOf(Math.max(...transactionsIds));
        var latestRow = result[indexOfMaximum]

        console.log("Post request on /payment-data");
        console.log(req.body);
        let sqlInsert = "INSERT INTO payment_data (`step`, `action`, `amount`, `amount_real`, `nameOrig`, `place`, `date`, `datetime`," +  
                    "`verwendungszweck`, `oldBalanceOrig`, `newBalanceOrig`, `nameDest`, `oldBalanceDest`, `newBalanceDest`, `isFraud`," + 
                    "`isFlaggedFraud`, `isUnauthorizedOverdraft`, `timestamp`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        console.log("Fire SQL Query...");
        console.log("Query: "+ sqlInsert);
        db.query(sqlInsert,
            [req.body.payment_data.step, req.body.payment_data.action, req.body.payment_data.amount, req.body.payment_data.amount_real, req.body.payment_data.nameOrig,
            latestRow["place"], req.body.payment_data.date, req.body.payment_data.datetime, req.body.payment_data.verwendungszweck, latestRow["newBalanceOrig"],
            (req.body.payment_data.action == "Cash-In") ? latestRow["newBalanceOrig"] + req.body.payment_data.amount : latestRow["newBalanceOrig"] - req.body.payment_data.amount,
            req.body.payment_data.nameDest, req.body.payment_data.oldBalanceDest, req.body.payment_data.newBalanceDest,
            req.body.payment_data.isFraud, req.body.payment_data.isFlaggedFraud, req.body.payment_data.isUnauthorizedOverdraft, req.body.payment_data.datetime_timestamp] 
            , (err, result) => {
            if(err){ 
                console.log("Sql Query err: " +err);
                res.status(500).send({error: {message: "Error: Payment Daten nicht abgespeichert."}})
            }
            console.log("Payment Daten erfolgreich abgespeichert.");
            res.status(200).send({data: {message: "Payment Daten erfolgreich abgespeichert." , error: 0} });
        });
    });
});

app.get('/users', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    let sql = "SELECT DISTINCT nameOrig FROM payment_data ORDER BY nameOrig LIMIT 10;";
    console.log("Fire SQL Query...");
    console.log("Query: "+ sql);
    db.query(sql, (err, result) => {
        if(err){
            console.log("Sql Query err: " +err);
            res.status(500).send({error: {message: "Error: Userabfrage nicht erfolgreich."}})
        }
        res.send(JSON.stringify(result));
    })
    // res.send(JSON.stringify([{"id": 1, "name": "Steven Gerard"}]));
});


app.listen('3000', () => {
    console.log('Server started on port 3000.');
});
