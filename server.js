'use strict';

var path = require('path');
var express = require('express');

GLOBAL.APPROOT = path.resolve(__dirname);

// Settings
var ServerConfig	= require(APPROOT + '/conf/server.json');

// Routers
var routerGet		= require(APPROOT + '/app/router.get.js');
var routerPost		= require(APPROOT + '/app/router.post.js');

var app = module.exports  = express();

app.get('/',				routerGet.home);			// TODO: Convert to API tutorial site.
app.get('/torrents',		routerGet.torrents);
app.get('/whitelist',		routerGet.whitelist);

app.post('/upload',			routerPost.upload);

var server = app.listen(ServerConfig.port, function () {

  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);

});