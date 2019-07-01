/* Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved. */
'use strict';

var fs = require('fs');
var path = require('path');

module.exports = function findBinary(packageJsonPath) {
  var pack = JSON.parse(fs.readFileSync(packageJsonPath));

  const nodeAbi = 'node-v' + process.versions.modules;

  var modulePath = pack.binary.module_path
    .replace('{module_name}', pack.binary.module_name)
    .replace('{node_abi}', nodeAbi)
    .replace('{platform}', process.platform)
    .replace('{arch}', process.arch);

  var resolvedPath = path.join(
    path.dirname(packageJsonPath),
    modulePath,
    pack.binary.module_name + '.node'
  );

  return resolvedPath;
};
