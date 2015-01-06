'use strict';

var mysql = require('mysql');

var MySQLConfig = require(APPROOT + '/conf/server.json').mysql;

GLOBAL.DATABASE_POOL = mysql.createPool(MySQLConfig);

exports.torrent	= require(APPROOT + '/app/libs/database/database.torrent.js');
exports.user	= require(APPROOT + '/app/libs/database/database.user.js');