#!/bin/bash
rm nodes.db
sqlite3 nodes.db "create table nodes(id INTEGER PRIMARY KEY AUTOINCREMENT, name char(30));"
