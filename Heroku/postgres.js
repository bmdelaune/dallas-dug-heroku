var pg = require('pg');

var connection_url = process.env.DATABASE_URL;

var client_i;

var connect_and_query = function(callback) {
  if(!client_i) {
    pg.connect(connection_url, function(err, client_temp, done) {
      console.log('connecting to postgresql');
      if(err) {
        console.error('error fetching client from pool', err);
        return;
      }
      console.log('connection successful');
      client_i = client_temp;
      callback(client_i);
    });
  }
  else
    callback(client_i);
}

var db = {};
db.contact = {};
db.feedback = {};

db.contact.get_all = function(callback) {
  connect_and_query(function(client) {
    client.query('SELECT * FROM sfdc.contact',callback);
  });
}

db.feedback.get_all = function(callback) {
  connect_and_query(function(client) {
    client.query('SELECT * FROM sfdc.feedback__c',callback);
  });
}

db.feedback.put_one = function(name,full_name,email,comments,callback) {
  connect_and_query(function(client) {
    client.query('INSERT INTO sfdc.feedback__c (name,full_name__c,email__c,comments__c) VALUES($1,$2,$3,$4) RETURNING sfid',[name,full_name,email,comments],callback);
  });
}

module.exports = db;