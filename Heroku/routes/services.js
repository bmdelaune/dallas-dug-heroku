var express = require('express');
var router = express.Router();
var db = require('../postgres');
var fs = require('fs');

router.route('/')
  .get(function(req, res) {
    fs.readFile('endpoints.json','utf8',function(err,data){
      if(err){
        console.log(err);
        res.status(500).end();
      }
      else {
        res.status(200);
        res.set({
          "Content-Type":"application/json; charset=utf8"
        });
        res.send(data);
      }
    })
  });

router.route('/contact/')
  .get(function(req, res) {
    db.contact.get_all(function(err, result) {
      if(err){
        console.log(err);
        res.status(500).end();
      } else {
        res.status(200);
        res.set({
          "Content-Type":"application/json"
        });
        res.send(JSON.stringify(result.rows));
      }
    });
  });

router.route('/feedback/')
  .post(function(req,res) {

    var name,email,comments,full_name;

    if(req.body.name) name = req.body.name;
    if(req.body.full_name) full_name = req.body.full_name;
    if(req.body.email) email = req.body.email;
    if(req.body.comments) comments = req.body.comments;
    console.log(name);
    console.log(full_name);
    console.log(email);
    console.log(comments);

    var emailRE = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i;
    if(emailRE.test(email)) {
      if(name && email && comments) {
        db.feedback.put_one(name,full_name,email,comments,function(err,result) {
          if(err) {
            console.log(err);
            res.status(500).end();
          } else {
            var location = '/services/rest/feedback/';
            if(result.rows.length > 0)
              location += result.rows[0].sfid;
            res.status(201);
            res.set({
              "Location":location
            });
            res.send();
          }
        });
      } else {
        res.status(400).send('Missing information.');
      }
    } else {
      res.status(400).send('Invalid email.');
    }

  })
  .get(function(req,res) {
    db.feedback.get_all(function(err, result) {
      if(err){
        console.log(err);
        res.status(500).end();
      } else {
        res.status(200);
        res.set({
          "Content-Type":"application/json; charset=utf8"
        });
        res.send(JSON.stringify(result.rows));
      }
    });
  });


/* GET default */
router.get('/*', function(req, res) {
  res.status(404).end();
});

module.exports = router;