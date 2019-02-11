<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="com.siemens.med.hs.icc.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.siemens.soarian.se.dates.Cali" %>
<%@ page import="com.siemens.med.hs.soarian.uia.sui.helpers.*"  %>
<%@ page import="com.siemens.med.hs.soarian.uia.util.sui.SuiUtils"%>
<%@ page import="com.siemens.med.hs.soarian.uia.sui.helpers.SuiProperties"%>
<%@ taglib uri="/SuiTLD" prefix="sui"%>
<%@ taglib prefix="icc" uri="/WEB-INF/tld/icc.tld"%>
<%@ taglib prefix="sframe" uri="/WEB-INF/tld/Sframe.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>

<icc:html>
<icc:head>
<title><fmt:message key='mdLocationCorrectionTool'/></title>
<sui:include module="uia" resource="uia.jsp" />
<sui:include resource="fixIframeForIE.jsp" module="sframe" />
<script src="<sui:js src='libs/require.js' />"></script>
<script src="<sui:js module='med' src='suimdIndicationWorkFrameObjectHandler.js' />"></script>
<script src="<sui:js module='med' src='SuimdIndicationRequiredAtLocationInclusion.js' />"></script>
<script src="<sui:js module='uia' src='messageDialog.js' />" ></script>
<script src="<sui:js module='dsk' src='SuidkHelp.js'/>" ></script>
<script src="<sui:js module='libs' src='jquery.js'/>"></script>
<link rel="stylesheet" type="text/css" href="<sui:style module='med' src='suimdLocationBasedMedication.css' />" />
<sui:_status value="${msgStatuses}" index="all" var="msgText" varcode="msgCode" dialogbox="false" scope="request" />
<sui:_status value="${msgStatuses}" var="msgText" varcode="msgCode" dialogbox="true" />
</icc:head>

<icc:body htmlAttr="class=mdScrollHidden">
  <icc:windowOnload>
     wfObjectForLocationCorrTool.setPathToWorkFrameObject(
     wfObjectForLocationCorrTool.createPathObjects(
     "<sui:path module='med'/>", 
     "<sui:path module='uia'/>", 
     "<sui:path module='dsk'/>", 
     "<sui:path module='ord'/>"));
     init("<fmt:message key="mdFormChanged"/>", "<fmt:message key="mdRFRErrTitle"/>", "<fmt:message key="mdYNOnly"/>");		 
  </icc:windowOnload>
	<div id="div-dialogBody" class="mdDivDialogBody mdDivWidth">
		<div id="div-medicationsTitleBar" class="mdDivMedicationTitleBar mdDivWidth">
			<div class="mdLocMedTitleBar mdLocMedTitleBarCommon mdLocWidthHeight mdDivAlign">
				 <b><fmt:message key="mdLocationCorrectionTool"/></b>
			</div>
		</div>
		<div id="div-medicationsIframeContainer" class="mdDivHeight mdDivmedicationsIframeContainer">
				<iframe id="iframeLocationIndCorr" name="iframeLocationIndCorr" class="mdLocMedTitleBarCommon mdScrolling" style="width:100%; height:500px;" src='<sframe:emptyPage/>'></iframe>
				<script>fixIframeForIE("iframeLocationIndCorr");</script>
		</div>
		<div id="div-footer">
			<span id="footer-help">
				<img src="<sui:img />Help_Button_01.gif" onclick="launchHelp('<fmt:message key='mdLocationCorrectionTool'/>');" title="<fmt:message key="prb_help"/>" />
			</span>
			<span id="footer-right">
			 <table class="hw100 " border-spacing="0%" border="0%" vertical-align="left">
			  <tr><td>
				<div style="width:70px; height:22px;" />
				    <fmt:message key='ok'/>
				<div style="width:70px; height:22px;" />
					<fmt:message key='apply'/>
				<div style="width:70px; height:22px;"/>
					<fmt:message key='close'/>
			  </tr></td>
			 </table>
			</span>
		</div>
	</div>
</icc:body>
</icc:html>
