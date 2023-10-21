<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
    <!-- Add Bootstrap CSS (you may need to provide the correct Bootstrap CSS URL) -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/WEB-INF/inc/menu.jsp"/>
<div class="container">
    <form action="/addMember" method="post">
        <div class="form-group">
            <label>이메일</label>
            <input type="email" name="emailId" class="form-control">
            <span class="memberEmailCheck"></span>
        </div>
        <div class="form-group">
            <label>비번</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="form-group">
            <label>비번확인</label>
            <input type="password" name="password2" class="form-control" required>
            <span class="passCheck"></span>
        </div>
        <div class="form-group">
            <label>이름</label>
            <input type="text" name="memberName" class="form-control" required>
        </div>
        <div class="form-group">
            <label>전화번호</label>
            <input type="text" name="phone" class="form-control">
        </div>
        <div class="form-group">
            <label>생일</label>
            <input type="date" name="birthday" class="form-control">
        </div>
        <div class="form-group">
            <label for="zipCode">우편번호</label>
            <input type="text" name="zipCode" id="zipCode" class="form-control" placeholder="우편번호" readonly>
            <input type="button" name="findCode" class="btn btn-primary" value="우편번호 찾기"/>
        </div>
        <div class="form-group">
            <label for="address01">번지수/도로명</label>
            <input type="text" name="address01" id="address01" class="form-control" placeholder="주소" readonly>
        </div>
        <div class="form-group">
            <label for="address02">상세주소</label>
            <input type="text" name="address02" id="address02" class="form-control" placeholder="상세주소">
        </div>
        <button type="submit" class="btn btn-primary">회원가입</button>
    </form>
</div>
<jsp:include page="/WEB-INF/inc/footer.jsp"/>
</body>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script>
    document.querySelector('input[name="findCode"]').addEventListener('click', execDaumPostcode);

    /* 카카오 우편번호 검색 가이드 페이지 :  https://postcode.map.daum.net/guide */
    function execDaumPostcode() {
        /* 상황에 맞춰서 변경해야 하는 부분 */
        const zipcode = document.getElementById('zipCode');
        const address01 = document.getElementById('address01');
        const address02 = document.getElementById('address02');

        /* 수정없이 사용 하는 부분 */
        new daum.Postcode({
            oncomplete: function (data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') {
                    // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;
                } else {
                    // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if (data.userSelectedType === 'R') {
                    //법정동명이 있을 경우 추가한다.
                    if (data.bname !== '') {
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if (data.buildingName !== '') {
                        extraAddr += extraAddr !== '' ? ', ' + data.buildingName : data.buildingName;
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += extraAddr !== '' ? ' (' + extraAddr + ')' : '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                zipcode.value = data.zonecode; //5자리 새우편번호 사용
                address01.value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                address02.focus();
            },
        }).open();
    }

    document.addEventListener("DOMContentLoaded", function () {
        const p1 = document.querySelector('input[name="password"]');
        const p2 = document.querySelector('input[name="password2"]');
        const c1 = document.querySelector(".passCheck");
        const lowercaseRegex = /[a-z]/;
        const digitRegex = /[0-9]/;

        p1.addEventListener("keyup", function () {
            if (p1.value.length < 8) {
                c1.style.color = "red"
                c1.innerHTML = "비밀번호는 여덟자 이상이어야 합니다";
            } else if (!lowercaseRegex.test(p1.value) || !digitRegex.test(p1.value)) {
                c1.style.color = "red"
                c1.innerHTML = "비밀번호는 반드시 영문(소문자)와 숫자를 포함해야 합니다!";
            } else {
                c1.style.color = "green"
                c1.innerHTML = "비밀번호가 유효합니다.";
            }
        });



        const xhr = new XMLHttpRequest();
        const emailId = document.querySelector('input[name=emailId]');
        emailId.addEventListener('keyup',function () {
            const emailIdval = emailId.value;
            const memberEmailCheck = document.querySelector('.memberEmailCheck'); //결과문자열
            xhr.open('GET','./ajaxIdCheck.jsp?emailId='+emailIdval );
            xhr.send();
            xhr.onreadystatechange = () => {
                if(xhr.readyState !== XMLHttpRequest.DONE) return;

                if(xhr.status === 200) {
                    const json = JSON.parse(xhr.response);
                    if(json.result === 'true') {
                        memberEmailCheck.style.color = 'red';
                        memberEmailCheck.innerHTML = '동일한 아이디가 있습니다!';
                    }
                    else {
                        memberEmailCheck.style.color = 'gray';
                        memberEmailCheck.innerHTML = '동일한 아이디가 없습니다.'
                    }
                }
                else {
                    console.error('Error',xhr.status,xhr.statusText);
                }
            }
        });
    });
</script>
</html>
