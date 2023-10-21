<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>정보수정</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

</head>
<body>
<jsp:include page="/WEB-INF/inc/menu.jsp" />
<nav class="custom-navbar navbar navbar navbar-expand-md navbar-dark bg-dark" arial-label="Furni navigation bar">

    <div class="container">
        <a class="navbar-brand"> 정보수정 <span>.</span></a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsFurni" aria-controls="navbarsFurni" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>


    </div>
</nav>
<div class="container" style="margin: 80px" >
    <form action="/member/modify" method="post">
        <div class="form-group">
            <label>이메일</label>
            <input type="email" name="emailId" value="${dto.emailId}" class="form-control" readonly>
        </div>
        <div class="form-group">
            <label>비밀번호 변경</label>
            <p><a href="/member/modifyPassword">비밀번호 변경</a></p>
        </div>
        <div class="form-group">
            <label >이름</label>
            <input type="text" name="memberName" value="${dto.memberName}" class="form-control" readonly>
        </div>
        <div class="form-group">
            <label >전화번호</label>
            <input type="text" name="phone" value="${dto.phone}" class="form-control" required>
        </div>
        <div class="form-group">
            <label >생일</label>
            <input type="date" name="birthday" value="${dto.birthday}" class="form-control" readonly>
        </div>
        <div class="form-group">
            <label for="zipCode">우편번호</label>
            <input type="text" name="zipCode" id="zipCode" class="form-control" placeholder="우편번호" value="${dto.zipCode}" readonly>
            <input type="button" name="findCode" style="margin-top: 20px" class="btn btn-primary" value="우편번호 찾기"/>
        </div>
        <div class="form-group">
            <label for="address01">번지수/도로명</label>
            <input type="text" name="address01" value="${dto.address01}" id="address01" class="form-control" placeholder="주소" readonly>
        </div>
        <div class="form-group">
            <label for="address02">상세주소</label>
            <input type="text" name="address02" value="${dto.address02}" id="address02" class="form-control" placeholder="상세주소">
        </div>
        <button name="modify" type="submit" class="btn btn-primary">정보수정</button>
        <a href="#" id="removeMemberLink" class="btn btn-danger">회원탈퇴</a>
    </form>
</div>
<jsp:include page="/WEB-INF/inc/footer.jsp" />
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script>
    document.getElementById('removeMemberLink').addEventListener('click', function (e) {
        e.preventDefault();
        var confirmRemove = confirm("정말로 회원을 탈퇴하시겠습니까?");
        if (confirmRemove) {
            window.location.href = "/removeMember";
        }
    });
    console.log(document.querySelector('input[name="findCode"]'));

    document.querySelector('input[name="findCode"]').addEventListener('click', execDaumPostcode);


    function execDaumPostcode() {
        const zipcode = document.getElementById('zipCode');
        const address01 = document.getElementById('address01');
        const address02 = document.getElementById('address02');

        new daum.Postcode({
            oncomplete: function (data) {
                var fullAddr = '';
                var extraAddr = '';

                if (data.userSelectedType === 'R') {
                    fullAddr = data.roadAddress;
                } else {
                    fullAddr = data.jibunAddress;
                }

                if (data.userSelectedType === 'R') {
                    if (data.bname !== '') {
                        extraAddr += data.bname;
                    }
                    if (data.buildingName !== '') {
                        extraAddr += extraAddr !== '' ? ', ' + data.buildingName : data.buildingName;
                    }
                    fullAddr += extraAddr !== '' ? ' (' + extraAddr + ')' : '';
                }

                zipcode.value = data.zonecode;
                address01.value = fullAddr;
                address02.focus();
            },
        }).open();
    }
</script>
</body>
</html>
