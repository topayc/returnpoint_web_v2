<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div class="modal fade m_point_transfer" id="rpoint_gift" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><spring:message code="label.pointGift"/></h4>
			</div>
			<form name="Frm2">
				<div class="modal-body">
					<div class="listmember">RPoint</div>
					<div class="listpoint"><small>P</small><span><fmt:formatNumber value="${model.myRedPointInfo.pointAmount}" pattern="###,###,###,###"/></span></div>
					<div class="pointinput">
						<div class="gift_user"><input type="text" id="redPointGiftMemberEmail10" name="redPointGiftMemberEmail10" placeholder="<spring:message code="label.mpointGiftMemberEnter"/>"><button type="button" onclick="searchPointGiftMemberEmail('10', 'rpoint_gift');"><spring:message code="label.msearch"/></button></div>
						<input type="hidden" name="redPointGiftMemberEmailOri10" id="redPointGiftMemberEmailOri10">
						<input type="number" placeholder="<spring:message code="label.mrpointTransformEnter"/>" id="rPoint10" name="rPoint10"  onblur="changeAttribute('rPoint10', 1, 'rpoint_gift');"/>			
						<button type="button" id="redthousandwon"><i class="fa fa-plus-circle"></i>1,000</button>
						<button type="button" id="redtenthousandwon"><i class="fa fa-plus-circle"></i>10,000</button>
						<button type="button" id="redfiftythousandwon"><i class="fa fa-plus-circle"></i>50,000</button>
						<button type="button" id="redonehundredthousandwon"><i class="fa fa-plus-circle"></i>100,000</button>			
					</div>
					<ul class="pointinfo">
						<li>- <spring:message code="label.mrpointSumTransforms"/> ${model.myRedPointInfo.pointAmount}</li>
						<li>- <spring:message code="label.mrpointMinTransforms"/> <fmt:formatNumber value="${model.selectPolicyMap.rPointMovingMinLimit}" type="number"/><spring:message code="label.mpoints"/></li>
					</ul>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-submit" onclick="redPointTransaction('10', '${model.myRedPointInfo.pointAmount}', '${model.myRedPointInfo.redPointNo}', 'rpoint_gift');"><spring:message code="label.mpointGiftSend"/></button>
				</div>
			</form>
		</div>
	</div>
</div>