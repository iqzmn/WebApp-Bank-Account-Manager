<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <style type="text/css">
        body {
            padding: 0;
            margin: 0;
            background-color: #484848;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            color: #CEC8D0;
        }
        #spam {
            background-color: #353436;
            border-radius: 5px;
            margin: 12% auto;
            width: 85%;
        }
        h1 {
            padding-top: 30px;
            font-size: 60px;
            font-family: Arial;
            text-align: center;
            border-bottom: 1px solid #333;
            border-bottom-style: dashed;
            padding-bottom: 20px;
        }
        p {
            text-align: center;
            font-family: Arial;
            font-weight: bold;
            padding-bottom: 3%;
        }
    </style>
</head>
<body>
<div id="spam">
    <h1>Access Denied(403)</h1>
    <p>Dear <strong>${loggedinuser}</strong>, You are not authorized to access this page.<br/><br/>
        <small>---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</small>
    <h3 style="text-align: center"><a href="/logout" class="btn btn-warning btn-lg" role="button">Logout</a></h3>
    </p>
</div>
</body>
</html>
