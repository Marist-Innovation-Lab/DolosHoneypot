/*
 * Copyright (c) 2014 Cisco Systems, Inc. and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 */

define(["app/node/nodes.module","app/node/nodes.services"],function(e){e.register.controller("rootNodeCtrl",["$rootScope",function(e){e.section_logo="logo_node"}]),e.register.controller("allNodesCtrl",["$scope","NodeInventorySvc","$timeout",function(e,t,n){t.getAllNodes().then(function(t){e.data=t[0].node});var r=!1;e.$watch("nodeSearch.id",function(){r&&n(function(){$(".footable").trigger("footable_redraw")},20)}),e.$on("lastentry",function(){r||($(".footable").footable(),r=!0)})}]),e.register.controller("nodeConnectorCtrl",["$scope","$stateParams","NodeInventorySvc","$timeout","nodeConnectorFactory",function(e,t,n,r,i){var s=n.getCurrentData();s!=null?s.then(function(n){var r=_.find(n[0].node,function(e){if(e.id==t.nodeId)return e});e.data=r}):n.getNode(t.nodeId).then(function(t){e.data=t.node[0]});var o=!1;e.$watch("nodeConnectorSearch",function(){o&&r(function(){$(".footable").trigger("footable_redraw")},20)}),e.$on("lastentry",function(){o||($(".footable").footable(),o=!0)}),e.checkActiveFlow=function(t){return i.getActiveFlow(e.data["flow-node-inventory:table"],t)}}])});