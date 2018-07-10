<%@page import="dao.OrderDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
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
<meta charset="utf-8">
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
	String id = (String) session.getAttribute("addOrderId");
	Map<String, OrderItem> mapItem = OrderItemDAO.getOrderItemByOrderId(id);
	//map total item price (each orderitem)
	Map<String, String> mapTotalItemPrice = OrderItemDAO.getLoadTotalItemPrice();
	//get total price map (each order)
	Map<String, String> mapTotalPrice = OrderDAO.getLoadTotalPrice();
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
					<button type="submit" class="btn btn-default">Tạo đơn hàng
						mới</button>
					<h4>Đơn hàng đã chọn</h4>
					<%
						String orderId = (String) session.getAttribute("addOrderId");
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
					<p>
						Mã đơn:
						<%=orderId%></p>
					<p>
						Ngày đặt:
						<%=orderDate%></p>
					<p>
						Mã khách hàng:
						<%=customerId%></p>

				</form>
			</div>
			<div class="col-md-2">
				<form action="order?function=addItem" method="post">
					<div class="form-group">
						<label for="productId">Mã sản phẩm</label> <input
							class="form-control" type="text" name="productId" id="productId"
							list="lstProductId">
					</div>
					<datalist id="lstProductId"> <%
 	for (Product product : ProductDAO.productMap.values()) {
 %>
					<option value="<%=product.getProductID()%>"><%=product.getProductName()%></option>
					<%
						}
					%> </datalist>
					<div class="form-group">
						<label for="quantity">Số lượng</label> <input class="form-control"
							type="number" name="quantity" min="1" id="quantity" value="1">
					</div>
					<button type="submit" class="btn btn-default">Thêm sản
						phẩm</button>
				</form>
			</div>
			<div class="col-md-6">
				<h2>
					Thông tin đơn đặt hàng:
					<%=orderId%></h2>
				<p>
					Ngày đặt hàng:
					<%=orderDate%></p>
				<p>
					Tổng giá trị đơn hàng:
					<%=totalPrice%></p>

				<!-- order item datatable -->
				<table id="datatable-buttons"
					class="table table-striped table-bordered">
					<thead>
						<tr>
							<th>STT</th>
							<th>Tên sản phẩm</th>
							<th>Số lượng</th>
							<th>Đơn giá</th>
							<th>Thành tiền</th>
						</tr>
					</thead>
					<tbody>
						<%
							int count = 0;
							for (OrderItem orderItem : mapItem.values()) {
								count++;
						%>
						<tr>
							<td><%=count%></td>
							<td><%=ProductDAO.productMap.get(orderItem.getProductID()).getProductName()%></td>
							<td><%=orderItem.getQuantity()%> <%
 	String price = ProductDAO.productMap.get(orderItem.getProductID()).getPrice();
 		price = ThousandSeparator.thousandSeparator(price) + " &#8363;";
 %>
							<td><%=price%></td>
							<td><%=mapTotalItemPrice.get(orderItem.getOrderItemId())%></td>

						</tr>
						<%
							}
						%>
					</tbody>
				</table>
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