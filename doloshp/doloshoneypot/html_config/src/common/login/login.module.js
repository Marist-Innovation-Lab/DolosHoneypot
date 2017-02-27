/*
 * Copyright (c) 2014 Inocybe Technologies, and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 */

define(["angularAMD","jquery","common/authentification/auth.services","ocLazyLoad"],function(e,t){var n=angular.module("app.common.login",["ngCookies","app.common.auth","ui.router.state"]);return n.config(["$stateProvider","$compileProvider","$controllerProvider","$provide","$httpProvider","$translateProvider",function(e,t,r,i,s,o){n.register={controller:r.register,directive:t.directive,factory:i.factory,service:i.service},e.state("login",{url:"/login",views:{"mainContent@":{templateUrl:"src/common/login/login.tpl.html",controller:"LoginCtrl"}},resolve:{loadController:["$ocLazyLoad",function(e){return e.load({files:["src/common/login/login.controller.js"]})}]}}),s.interceptors.push("NbInterceptor")}]),n.run(["$rootScope","$location","Auth",function(e,n,r){var i=["/login"],s=function(e){var n=!1;return t.each(i,function(t,r){n=n||e.match("^"+r)}),n};e.$on("$stateChangeStart",function(){!s(n.url())&&!r.isAuthed()&&n.path("/login")})}]),n});