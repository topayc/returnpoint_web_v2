<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head> 
<title>ReturnP</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<!-- css   -->
<!-- font -->
<link rel="stylesheet" href="/resources/css/common.css">
<!-- js -->
<script type="text/javascript" src="/resources/js/lib/jquery.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/bootstrap.min.js"></script>
<script type="text/javascript" src="/resources/js/lib/jquery.cookie.js"></script>
<script type="text/javascript" src="/resources/js/lib/common.js"></script>
<script type="text/javascript">
jQuery(function($) {'use strict';
/* onepage scroll */
	$(window).scroll(function(event) {
		Scroll();
	});
	$('.vertical-scroll li a').on('click', function() {  
		$('html, body').animate({scrollTop: $(this.hash).offset().top - 5}, 1000);
		return false;
	});
	// User define function
	function Scroll() {
		var contentTop      =   [];
		var contentBottom   =   [];
		var winTop      =   $(window).scrollTop();
		var rangeTop    =   200;
		var rangeBottom =   500;
		$('.vertical-scroll').find('.scroll a').each(function(){
			contentTop.push( $( $(this).attr('href') ).offset().top);
			contentBottom.push( $( $(this).attr('href') ).offset().top + $( $(this).attr('href') ).height() );
		})
		$.each( contentTop, function(i){
			if ( winTop > contentTop[i] - rangeTop ){
				$('.vertical-scroll li')
				.removeClass('active')
				.eq(i).addClass('active');			
			}
		})
	};
/* onepage scroll */
});
</script>
</head>
<!-- header end -->
<!-- body begin -->
<body>		
	<div class="main_header">
		<nav>
			<div class="nav-brand"><a href="#home"><img src="/resources/images/n_logo.png" class="logo_img" /></a></div>
			<!-- vertical scroll begin -->
			<ul class="vertical-scroll">
				<li class="scroll active"><a href="#returnp">RETURNP</a></li>
				<li class="scroll"><a href="#service">SERVICE</a></li>
				<li class="scroll"><a href="#partners">PARTNERS</a></li>
				<li class="scroll"><a href="#contact">CONTACT</a></li>          
			</ul>		
			<!-- vertical scroll end -->
			<ul class="right_menu">
				<li>login / join</li>
				<li><img src="/resources/images/n_appdown.png" /> APP</li>
				<li></li>
			</ul>
		</nav>		
		<div class="main_txt_area">
			<p>스마트하게 <span class="">사고</span></p>
			<p>스마트하게 <span class="">쌓고</span></p>
			<p>스마트하게 <span class="">쓴다 !</span></p>
			<p class="subtxt">쓴만큼 돌려받는 ReturnP에 대해 알아보아요!</p>
		</div>
		<div class="main_header_bottom">
			<img src="main_header_bottom.png" />
		</div>
		<ul>
			<li><img src="main_header_bottom.png" /></li>
			<li></li>
			<li></li>
		</ul>
	</div>	
	<!-- main begin -->
	<section id="returnp" style="height:500px;background-color:ccc;">
	returnp
	</section>
    <section id="service" style="height:500px;background-color:fff;">
	service
	</section>
    <section id="partners" style="height:500px;background-color:ccc;">
	partners
	</section>
    <section id="contact" style="height:500px;background-color:fff;">
		contact
	</section>
	<footer>
		<div>
			<span>Monday-Thursday 11:30am - 9:30pm</span>
			<span>Friday 11:30am - 10:00pm</span>
			<span>Saturday 3:00pm - 10:00pm</span>
			<span>Sunday 3:00pm - 9:00pm</span>
		</div>
		<small><a href="https://montiya.com">Site created by Montiya.com</a></small>
	</footer>
	<!-- main end -->	
</body>
<!-- body end -->
</html>
