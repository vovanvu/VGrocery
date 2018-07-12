
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Customer"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="model.Product"%>
<%@page import="dao.ProductDAO"%>
<%@page import="dao.ProductDAO"%>
<%@page import="dao.OrderDAO"%>
<%@page import="dao.OrderItemDAO"%>
<%@page import="model.Order"%>
<%@page import="model.ConnectDTB"%>
<%@page import="model.Customer"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="model.OrderItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.ThousandSeparator"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Thông tin đơn đặt hàng</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Thêm đơn hàng</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- datatable -->
<!-- Bootstrap -->
<link href="vendors/bootstrap/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link href="vendors/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<!-- Datatables -->
<link href="vendors/datatables.net-bs/css/dataTables.bootstrap.min.css"
	rel="stylesheet">
<link
	href="vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css"
	rel="stylesheet">
<link
	href="vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css"
	rel="stylesheet">
<link
	href="vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css"
	rel="stylesheet">
<link
	href="vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css"
	rel="stylesheet">
</head>
<%
	String orderId = (String) session.getAttribute("addOrderId");
	//map order item of order
	Map<String, OrderItem> mapItem = OrderItemDAO.getOrderItemByOrderId(orderId);
	//map total item price (each orderitem)
	Map<String, String> mapTotalItemPrice = OrderItemDAO.getLoadTotalItemPrice();
	//get total price map (each order)
	Map<String, String> mapTotalPrice = OrderDAO.getLoadTotalPrice();
	//manage null
	String orderDate = "";
	String customerId = "";
	String totalPrice = "";
	Order order = OrderDAO.orderMap.get(orderId);
	if (order == null) {
		orderId = "Chưa chọn";
		orderDate = "Chưa chọn";
		customerId = "Chưa chọn";
		totalPrice = "0 &#8363;";
	}
	if (order != null) {
		orderDate = OrderDAO.orderMap.get(order.getOrderId()).getOrderDate();
		customerId = OrderDAO.orderMap.get(order.getOrderId()).getCustomerId();
		if (mapTotalPrice.get(order.getOrderId()) == null) {
			totalPrice = "0 &#8363;";
		} else {
			totalPrice = mapTotalPrice.get(order.getOrderId());
		}
	}
%>
<body>
	<jsp:include page="../menu/menu.jsp"></jsp:include>
	<div class="container">
		<ul class="breadcrumb">
			<li><a href="index.jsp">Trang chủ</a></li>
			<li><a href="showOrder.jsp">Quản lý đơn hàng</a></li>
			<li><a href="#">Thêm đơn đặt hàng</a></li>
		</ul>
		<div class="row">
			<div class="col-md-2">
				<form action="order?function=selectCustomer" method="post">
					<div class="form-group">
						<label for="customerId">Mã khách hàng</label> <input
							class="form-control" type="text" name="customerId"
							id="customerId" list="lstCustomerId">
					</div>
					<div class="form-group">
						<label for="orderDate">Chọn ngày đặt hàng</label> <input
							type="date" class="datepicker form-control" id="orderDate"
							name="orderDate" />
					</div>
					<datalist id="lstCustomerId"> <%
 	for (Customer customer : CustomerDAO.customerMap.values()) {
 %>
					<option value="<%=customer.getCustomerID()%>"><%=customer.getCustomerName()%></option>
					<%
						}
					%> </datalist>
					<button type="submit" class="btn btn-success">Tạo đơn hàng
						mới</button>
					<div class="well" style="margin-top:10px">
						<strong>Đơn hàng đang chọn:</strong>
						<hr>
						<p>
							Mã đơn: <%=orderId%>
							</p>
						<p>
							Ngày đặt:
							<%=orderDate%></p>
						<p>
							Mã khách hàng:
							<%=customerId%></p>
					</div>

				</form>
			</div>
			<div id="addOrderItem">
				<%
					if (order != null) {
				%>
				<jsp:include page="../product/addOrderItem.jsp"></jsp:include>
				<%
					}
				%>
			</div>
		</div>
	</div>

	<!-- jQuery -->
	<script src="vendors/jquery/dist/jquery.min.js"></script>
	<!-- Bootstrap -->
	<script src="vendors/bootstrap/dist/js/bootstrap.min.js"></script>
	<script src="vendors/datatables.net/js/jquery.dataTables.min.js"></script>
	<script src="vendors/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
	<script
		src="vendors/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
	<script
		src="vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
	<script src="vendors/datatables.net-buttons/js/buttons.flash.min.js"></script>
	<script src="vendors/datatables.net-buttons/js/buttons.html5.min.js"></script>
	<script src="vendors/datatables.net-buttons/js/buttons.print.min.js"></script>

	<!-- Custom Theme Scripts -->
	<script src="build/js/custom.min.js"></script>
</body>
</html>