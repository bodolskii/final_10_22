<%@ page import="com.example.mongchi_shop.dto.MemberDTO" %>
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginInfo");
    String emailId = null;
    if (memberDTO != null) {
        emailId = memberDTO.getEmailId();
    }
%>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/review_star.css">
    <title>리뷰</title>
    <%-- 별점 style --%>
    <style>
        body {
            height: 1500px;
        }

        .review-container .table {
            width: 100%;
            border: none; /* Remove table border */
        }

        /* Increase padding for better content area */
        .review-container .table th,
        .review-container .table td {
            padding: 15px;
        }

    </style>
    <%-- 별점 style/ --%>
</head>

<body>
<jsp:include page="/WEB-INF/inc/menu.jsp" />
<nav class="custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark" arial-label="Furni navigation bar">

    <div class="container">
        <a class="navbar-brand">나의 리뷰 목록<span>.</span></a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <jsp:include page="/WEB-INF/inc/mypageNavi.jsp" />
    </div>
</nav>

<!-- 주요 내용 섹션 -->
<div class="container mt-4" >
    <div class="row">
        <!-- 리뷰 목록 -->
        <div class="col-xl-12 mx-5">
            <br>
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="thead-dark">
                    <tr align="center">
                        <th>번호</th>
                        <th>리뷰이미지</th>
                        <th>내용</th>
                        <th>별점</th>
                        <th>리뷰 작성일</th>
                        <th colspan="2">비고</th>
                    </tr>
                    </thead>
                    <!-- 테이블 본문 -->
                    <tbody align="center">
                    <c:forEach var="myReview" items="${myreviewDTOList}" varStatus="status">
                        <tr align="center" class="writer">
                            <td style="font-size: 20px; vertical-align: middle;">${status.index + 1}</td>
                            <td style="vertical-align: middle"><img src="${myReview.fileName}" style="width: 100px;"></td>
                            <td style="width: 500px; vertical-align: middle;" >${myReview.content}</td>
                            <td style="vertical-align: middle">
                                <span class="star">
                                    ★★★★★
                                    <span style="width: ${myReview.rate * 10}%;">★★★★★</span>
                                    <input type="range" value="${myReview.rate}" step="1" min="1" max="10">
                                </span>
                            </td>
                            <td style="vertical-align: middle;">
                                    ${myReview.addDate}
                            </td>
                            <td>
                                <form action="/review/modify" method="get" class="buttons">
                                    <input type="hidden" name="rno" value="${myReview.rno}">
                                    <input type="hidden" name="pno" value="${myReview.pno}">
                                    <button class="btn btn-warning btn-sm" style="background-color: #0f5132; border: #0f5132; margin-top: 30px" >수정</button>
                                </form>
                            </td>
                            <td>
                                <form action="/review/remove" method="get" onsubmit="return confirmDelete()">
                                    <input type="hidden" name="pno" value="${myReview.pno}">
                                    <input type="hidden" name="rno" value="${myReview.rno}">
                                    <button type="submit" class="btn btn-danger btn-sm"
                                            style="background-color: #fa1b1b; border: #fa1b1b; margin-top: 30px" >삭제</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 리뷰 목록/ -->
    </div>
</div>
<!-- 주요 내용 섹션/ -->

<jsp:include page="/WEB-INF/inc/footer.jsp" />

<script>
    // 삭제 여부를 확인하는 JavaScript 함수
    function confirmDelete() {
        let result = window.confirm("정말 삭제하시겠습니까?");
        return result;
    }

    // 일정 시간이 지난다면 버튼이 사라지게 하는 코드
    document.addEventListener('DOMContentLoaded', function () {
        // 리뷰 등록된 날짜 가져오기
        let reviewDateStr = '${myReview.addDate}';
        console.log('Original Date String:', reviewDateStr); // 디버깅 메시지

        if (reviewDateStr) {
            // 'YYYY-MM-DD HH:mm:ss' 형식의 문자열을 날짜 객체로 변환
            let [datePart, timePart] = reviewDateStr.split(' ');

            console.log('Time Part:', timePart);  // 디버깅 메시지

            if (timePart !== undefined) { // timePart가 존재하는 경우에만 진행
                let [year, month, day] = datePart.split('-');
                let [hours, minutes, seconds] = timePart.split(':');

                try {
                    // 예외 발생 가능한 부분
                    let reviewDate = new Date(year, month - 1, day, hours, minutes, seconds);

                    // 현재 날짜 가져오기
                    let currentDate = new Date();

                    // 일정 시간 (예: 7일) 이상 지났는지 확인
                    let timeDifference = currentDate - reviewDate;
                    let timeThreshold = 7 * 24 * 60 * 60 * 1000; // 7일을 밀리초로 변환

                    console.log('Time Difference:', timeDifference);  // 디버깅 메시지

                    if (timeDifference > timeThreshold) {
                        // 시간이 일정 기간 이상 지났으면 버튼 숨기기
                        let myButton = document.querySelector('.buttons .btn');
                        if (myButton) {
                            myButton.style.display = 'none';
                        }
                    }
                } catch (error) {
                    console.error('Error parsing date:', error);
                }
            }
        }
    });
</script>
</body>
</html>
