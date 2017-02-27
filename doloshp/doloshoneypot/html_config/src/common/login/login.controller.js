/*
 * Copyright (c) 2014 Inocybe Technologies, and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 */

define(["common/login/login.module","common/authentification/auth.services"],function(e){e.register.controller("LoginCtrl",["$cookieStore","$scope","$http","$window","Auth","$location",function(e,t,n,r,i,s){t.login={},t.login.username="",t.login.password="",t.login.remember=!1,t.rememberme=!0,t.sendLogin=function(){i.login(t.login.username,t.login.password,t.success,t.error)},t.success=function(e){r.location.href="index.html"},t.error=function(e){t.error="Unable to login"}}]),e.register.controller("forgotPasswordCtrl",["$scope","$http",function(e,t){e.recover={},e.recover.email="",e.sendForgotPassword=function(){t.post("/recover",e.recover).success(function(e){e.recover?console.log("email sent"):console.log("email not sent")})}}]),e.register.controller("registerCtrl",["$scope","$http",function(e,t){e.register={},e.register.email="",e.register.username="",e.register.password="",e.register.repeatPassword="",e.register.userAgreement=!1,e.sendRegister=function(){t.post("/register",e.register).success(function(e){e.register?console.log("registration is successful"):console.log("registration failed")})}}])});