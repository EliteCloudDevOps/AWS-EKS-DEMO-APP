var express = require('express');
var app = express();
var uuid = require('node-uuid');

var pg = require('pg');
require('dotenv').config();


/** 
 * App port and app host added 
 */ 

const APP_PORT = '3001'
const APP_HOST = '0.0.0.0';

app.set('port', APP_PORT);
app.set('host', APP_HOST);
// app.listen(APP_PORT, () => {
//   console.log(`listening on port ${APP_PORT}`)
//   console.log(`DB HOST is ${process.env.DBHOST}`)
// })

const conString = {
    user: process.env.DBUSER,
    database: process.env.DB,
    password: process.env.DBPASS,
    host: process.env.DBHOST,
    port: process.env.DBPORT,                
};

app.listen(APP_PORT, () => {
  console.log(`listening on port ${APP_PORT}`)
  // console.log(`DB HOST is ${process.env.DBHOST}`)
  // console.log(`DB PASS is ${conString.password}`)
})
// Routes
app.get('/api/status', function(req, res) {
//'SELECT now() as time', [], function(err, result
  
  const Pool = require('pg').Pool
  const pool = new Pool(conString)
  // connection using created pool
  pool.connect((err, client, release) => {
    if (err) {
      return console.error('Error acquiring client', err.stack)
    }
    client.query('SELECT now() as time', (err, result) => {
      release()
    if (err) {
      console.log(err);
      return console.error('Error executing query', err.stack)
    }
    res.status(200).send(result.rows);
  });
});

  // pool shutdown
  pool.end()
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});


module.exports = app;
