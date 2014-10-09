#!/usr/bin/env python

import bicycledataprocessor as bdp

dataset = bdp.DataSet()
dataset.create_database()
dataset.fill_all_tables()
