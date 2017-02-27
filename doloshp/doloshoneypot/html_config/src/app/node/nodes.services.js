/*
 * Copyright (c) 2014 Cisco Systems, Inc. and others.  All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v1.0 which accompanies this distribution,
 * and is available at http://www.eclipse.org/legal/epl-v10.html
 */

define(["app/node/nodes.module"],function(e){e.register.factory("nodeConnectorFactory",function(){var e={};return e.getActiveFlow=function(e,t){var n=e[t],r=n["opendaylight-flow-table-statistics:flow-table-statistics"]["opendaylight-flow-table-statistics:active-flows"];return r>0},e}),e.register.factory("NodeRestangular",["Restangular","ENV",function(e,t){return e.withConfig(function(e){e.setBaseUrl(t.getBaseURL("MD_SAL"))})}]),e.register.factory("NodeInventorySvc",["NodeRestangular",function(e){var t={base:function(){return e.one("restconf").one("operational").one("opendaylight-inventory:nodes")},data:null};return t.getCurrentData=function(){return t.data},t.getAllNodes=function(){return t.data=t.base().getList(),t.data},t.getNode=function(e){return t.base().one("node",e).get()},t}])});