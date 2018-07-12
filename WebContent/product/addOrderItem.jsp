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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
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
	<div class="col-md-3">
		<form action="order?function=addItem" method="post">
			<div class="form-group">
				<label for="productId">Mã sản phẩm</label><select name="productId"
					class="form-control">
					<option value="" selected disabled hidden>Chọn sản phẩm</option>
					<%
						for (Product product : ProductDAO.productMap.values()) {
					%>
					<option value="<%=product.getProductID()%>"><%=product.getProductName()%></option>
					<%
						}
					%>

				</select>
			</div>
			<%--
					 <input
							class="form-control" type="text" name="productId" id="productId"
							list="lstProductId"> 
					<datalist id="lstProductId"> <%
 	for (Product product : ProductDAO.productMap.values()) {
 %>
					<option value="<%=product.getProductID()%>"><%=product.getProductName()%></option>
					<%
						}
					%> </datalist> --%>
			<div class="form-group">
				<label for="quantity">Số lượng</label> <input class="form-control"
					type="number" name="quantity" min="1" id="quantity" value="1">
			</div>
			<button type="submit" class="btn btn-success">Thêm sản phẩm</button>
		</form>
	</div>
	<div class="col-md-7">
		<h2>
			Thông tin đơn đặt hàng:
			<%=orderId%></h2>
		<p>
			Ngày đặt hàng:
			<%=orderDate%></p>
		<p>
			Mã khách hàng:
			<%=customerId%></p>

		<p>
			Tổng giá trị đơn hàng:
			<%=totalPrice+ " \u20AB"%></p>
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
 		price = ThousandSeparator.thousandSeparator(price);
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
</body>
</html>