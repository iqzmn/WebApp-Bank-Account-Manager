<%--<jsp:useBean id="user" scope="request" type="com.exchange.model.User"/>--%>
<%--<jsp:useBean id="account" scope="request" type="com.exchange.model.UserAccount"/>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>Account Manager</title>
    <link href="<c:url value='/static/css/bs/bootstrap.css'/>" rel="stylesheet"/>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
    <script src="<c:url value='/static/js/jquery-3.3.1.min.js'/>"></script>
    <style>
        .alert-message .alert-icon {
            width: 3rem;
        }
        .alert-message .close{
            font-size: 1rem;
            color: #a6a6a6;
        }
        .alert-success .alert-icon {
            background-color: #c3e6cb;
        }
    </style>
</head>
<body style="background-color:#484848; color: #CEC8D0">
<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <span class="navbar-brand">#${account.accountNumber}</span>
    <div class="navbar-collapse collapse justify-content-stretch">
        <ul class="navbar-nav" style="position: absolute; left: 50%; transform: translateX(-50%)">
            <li class="nav-item"><span class="navbar-brand">Total Balance: <span style="color: rgb(23,137,0)">$${sum}</span></span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <span class="ml-auto navbar-brand">${user.firstName}&nbsp;${user.lastName}</span>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle mr-3 mr-lg-0" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="far fa-user" style="color:rgb(23,137,0)"></i><span class="caret"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="<c:url value='/userPage'/>">My accounts</a>
                    <a class="dropdown-item" href="<c:url value='/user-profile-${user.ssoId}'/>">Profile</a>
                    <a class="dropdown-item" href="<c:url value='/logout' />">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<br><br>
<div class="container">
    <div class="row justify-content-md-center">
        <div class="col-7">
            <div>
                <h4>Account balance: $${account.amount}</h4>
            </div>
            <br>
            <form:form action="/refill-${user.id}-${account.id}" modelAttribute="userAccount" method="post" class="py-1" id="deposit">
                    <div class="input-group mb-1">
                        <c:set var="limit" scope = "session" value="${99999999-account.amount}"/>
                        <form:input type="text" class="form-control" path="amount" required="required" id="amount" placeholder="min 0 max ${limit}"/>
                        <div class="input-group-append">
                            <span class="input-group-text">$</span>
                        </div>
                        <button id="add" value="" style="margin-left: 5%; width: 93px;" type="submit" class="btn btn-outline-success">Refill</button>
                    </div>
                    <div>
                        <label for="amount" class="error" style="color: red"></label>
                    </div>
                </form:form>
            <form:form action="/withdraw-${user.id}-${account.id}" modelAttribute="userAccount" method="post" class="py-1" id="withdraw">
                    <div class="input-group mb-1">
                        <form:input type="text" class="form-control" path="amount" required="required" id="amount" placeholder="min 0 max ${account.amount}"/>
                        <div class="input-group-append">
                            <span class="input-group-text">$</span>
                        </div>
                        <button style="margin-left: 5%" type="submit" class="btn btn-outline-danger">Withdraw</button>
                    </div>
                    <div>
                        <label for="amount" class="error" style="color: red"></label>
                    </div>
                </form:form>
            <form:form action="/transfer-${user.id}-${account.id}" modelAttribute="userAccount" method="post" class="py-1" id="transfer">
                <div class="form-row">
                    <div class="col">
                        <div class="input-group" style="width: 250px">
                            <div class="input-group-prepend">
                                <label class="input-group-text" for="accountNumber">#</label>
                            </div>
                            <%--<form:input type="text" path="accountNumber" class="form-control" placeholder="account"/>--%>
                            <form:select class="custom-select" id="accountNumber" path="accountNumber">
                                <c:forEach items="${accounts}" var="acc">
                                    <option id="accountNumber"><c:out value="${acc.accountNumber}"/></option>
                                </c:forEach>
                            </form:select>
                        </div>
                        <label for="accountNumber" class="error" style="color: red"></label>
                    </div>
                    <div class="col">
                        <div class="input-group" style="width: 250px">
                            <form:input type="text" path="amount" class="form-control" placeholder="min 0 max ${account.amount}"/>
                            <div class="input-group-append">
                                <span class="input-group-text">$</span>
                            </div>
                        </div>
                        <label for="amount" class="error" style="color: red"></label>
                    </div>

                    <div class="col">
                        <button style="width: 93px; margin-left: 19%" type="submit" class="btn btn-outline-primary">Transfer</button>
                    </div>
                </div>
                </form:form>
            <br>
            <c:if test="${param.success != null}">
                <div class="alert alert-success alert-message d-flex rounded p-0" role="alert">
                    <div class="alert-icon d-flex justify-content-center align-items-center flex-grow-0 flex-shrink-0 py-3">
                        <i class="fa fa-check"></i>
                    </div>
                    <div class="d-flex align-items-center py-2 px-3">
                        The operation completed successfully!
                    </div>
                    <a href="#" class="close d-flex ml-auto justify-content-center align-items-center px-3" data-dismiss="alert">
                        <i class="fas fa-times"></i>
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    $(function()
    {
        $("#deposit").validate({
            rules:{
                amount:
                {
                    number:true,
                    range:[0,99999999-${account.amount}]
                }
            }
        });

        $("#withdraw").validate({
            rules:{
                amount:
                {
                    number:true,
                    range:[0,${account.amount}]
                }
            }
        });

        $("#transfer").validate({
            rules:{
                amount:
                {
                    required:true,
                    number:true,
                    range:[0,${account.amount}]
                }
                // accountNumber:
                // {
                //     required:true,
                //     number:true,
                //     minlength:7,
                //     maxlength:8
                // }
            }
        });
    });
</script>
<script src="<c:url value='/static/js/jquery.validate.min.js'/>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="<c:url value='/static/js/bootstrap.min.js'/>"></script>
</body>
</html>
