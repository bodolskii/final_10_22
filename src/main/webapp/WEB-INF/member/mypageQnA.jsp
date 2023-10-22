<%@ page import="com.example.mongchi_shop.dto.ProductDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.mongchi_shop.dto.CartDTO" %>
<%@ page import="com.example.mongchi_shop.dto.MemberDTO" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2023-10-13
  Time: 오전 6:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<CartDTO> cartDTOList = (List<CartDTO>) session.getAttribute("cartDTOList");
%>

<html>
<head>
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="/css/tiny-slider.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <title>qna</title>
    <title>마이페이지</title>
</head>

<body>
<jsp:include page="/WEB-INF/inc/menu.jsp"/>

<nav class="custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark" arial-label="Furni navigation bar">

    <div class="container">
        <a class="navbar-brand">마이 페이지<span>.</span></a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <jsp:include page="/WEB-INF/inc/mypageNavi.jsp" />
    </div>
</nav>
<%
    List qnABoardDTOList=(List) request.getAttribute("qnABoardDTOList");
    int currentPage=(Integer) request.getAttribute("currentPage");
    int totalPage=(Integer) request.getAttribute("totalPage");

    int pagePerBlock=5; // 페이지 출력 시 나올 범위
    int totalBlock=totalPage%pagePerBlock==0 ? totalPage / pagePerBlock : totalPage / pagePerBlock+1; // 전체 블럭 수
    int thisBlock=((currentPage-1)/pagePerBlock)+1; // 현재 블럭
    int firstPage=((thisBlock-1)*pagePerBlock)+1; // 블럭의 첫 페이지
    int lastPage=thisBlock*pagePerBlock; // 블럭의 마지막 페이지
    lastPage=(lastPage>totalPage)?totalPage:lastPage;




  MemberDTO memberDTO= (MemberDTO) session.getAttribute("loginInfo");
  String emailId = memberDTO.getEmailId();
%>
<section class="ftco-section " style="height: 70%" >
    <div class="container">
        <div class="row justify-content-center"></div>
        <div class="row">
            <div class="col-md-12">
                <h3 class="h5 mb-4 text-center"></h3>
                <div>
                    <table class="table myaccordion table-hover" id="accordion">
                        <thead>
                        <tr>
                            <th>답변 여부</th>
                            <th>아이디</th>
                            <th>내용</th>
                            <th>작성일</th>

                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="qnaDto" items="${qnABoardDTOList}">
                            <c:set value="<%=emailId%>" var="email" />
                            <tr data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                <td>${qnaDto.isAnswered() ? "답변 완료" : "미답변"}</td>
                                <td>${qnaDto.getEmailId()}</td>
                                <c:if test="${qnaDto.secreted == true}">
                                    <c:choose>
                                        <c:when test="${qnaDto.getEmailId() eq email}">
                                             <td>${qnaDto.questionContent}</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td><i class="fa-solid fa-lock"></i>&nbsp;비밀글입니다</td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${qnaDto.secreted == false}">
                                    <td>${qnaDto.questionContent}</td>
                                </c:if>
                                <td>${qnaDto.getQuestionDate()}</td>
                                <td><a href="/qnaBoard/modifyQuestion?qno=${qnaDto.qno}&pno=${qnaDto.pno}" value="수정"/>수정하기</td>
                            </tr>
                        </c:forEach>

                        <%--              답변 영역 --%>
                        <c:forEach var="qnaDto" items="${qnABoardDTOList}">
                            <tr>
                                <c:if test="${qnaDto.secreted == true && qnaDto.answered == true}">
                                    <c:choose>
                                        <c:when test="${qnaDto.emailId eq email}">
                                            <td colspan="6">${qnaDto.questionContent}</td>
                                            <td colspan="6">${qnaDto.answerContent}</td>
                                            <td colspan="6">${qnaDto.answerDate}</td>
                                        </c:when>
                                    </c:choose>
                                </c:if>
                                <c:if test="${qnaDto.secreted == false && qnaDto.answered == true}">
                                    <td>${qnaDto.questionContent}</td>
                                    <td>${qnaDto.answerContent}</td>
                                    <td>${qnaDto.answerDate}</td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>







<%--<div></div>--%>

<!-- 페이지 -->
<div>
    <c:set var="currentPage" value="<%=currentPage%>"/>

    <ul class="pagination flex-wrap justify-content-center">
        <c:if test="${thisBlock>1}">
            <li class="page-item">
                <a class="page-link" data-num="<%=firstPage-1%>">prev</a>
            </li>
        </c:if>
        <c:forEach var="num" begin="<%=firstPage%>" end="<%=lastPage%>">
            <li class="page-item ${currentPage == num ? "active" : ""}">
                <a class="page-link" data-num="${num}">${num}</a>
            </li>
        </c:forEach>
        <c:if test="<%=thisBlock<totalBlock%>">
            <li class="page-item">
                <a href="#" class="page-link" data-num="<%=lastPage+1%>">next</a>
            </li>
        </c:if>
    </ul>
</div>

<script>
    document.querySelector('.pagination').addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        const target = e.target;
        if(target.tagName !== 'A') {
            return;
        }
        const num = target.getAttribute('data-num');
        self.location = `/member/myQnA?currentPage=\${num}`;
    });
</script>
</div>
</ul>






<jsp:include page="/WEB-INF/inc/footer.jsp" />
</body>
</html>
