/*
 * Copyright (c) 2014 Inocybe Technologies, and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 */

define(["angularAMD","common/config/env.module"],function(e){var t=angular.module("app.common.auth",["config"]);return t.config(["$compileProvider","$controllerProvider","$provide",function(e,n,r){t.register={controller:n.register,directive:e.directive,factory:r.factory,service:r.service}}]),t});