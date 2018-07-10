package controller;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.OrderDAO;
import dao.OrderItemDAO;
import model.ConnectDTB;
import model.IdGenerator;
import model.Order;
import model.OrderItem;

/**
 * Servlet implementation class OrderController
 */
@WebServlet("/orderOld")
public class OrderControllerMaterialize extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public OrderControllerMaterialize() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String func = request.getParameter("function");
		switch (func) {
		case "add":
			RequestDispatcher addDispatcher = request.getRequestDispatcher("order/addOrder.jsp");
			addDispatcher.forward(request, response);
			break;
		case "delete":
			deleteOrder(request, response);
			break;
		case "selectCustomer":
			RequestDispatcher selectDispatcher = request.getRequestDispatcher("order/addOrder.jsp");
			selectDispatcher.forward(request, response);
			break;
		case "detail":
			RequestDispatcher detailDispatcher = request.getRequestDispatcher("order/detailOrder.jsp");
			detailDispatcher.forward(request, response);
			break;
		}
	}

	private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String id = request.getParameter("id");
		new OrderDAO().delete(id);
		response.sendRedirect("showOrder.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String customerId = (String) request.getSession().getAttribute("id");
		String orderDate = (String) request.getSession().getAttribute("date");
		if (customerId == "" || orderDate == "") {
			RequestDispatcher addDispatcher = request.getRequestDispatcher("order/addOrder.jsp");
			addDispatcher.forward(request, response);
		} else {
			String orderId = IdGenerator.IDGen("OD");
			Order order = new Order(orderId, orderDate, customerId);
			new OrderDAO().add(order);
			// add order item
			String[] listProductId = request.getParameterValues("productId");
			String[] listQuantity = request.getParameterValues("quantity");
			if (listProductId == null) {
				System.out.println("No product info");
			} else {
				for (int i = 0; i < listProductId.length; i++) {
					// id random 100 -1000
					String orderItemId = IdGenerator.IDGen("ODI");
					OrderItem item = new OrderItem(orderItemId, listProductId[i], listQuantity[i], orderId);
					new OrderItemDAO().add(item);
				}
			}
			response.sendRedirect("showOrder.jsp");
		}
	}
}
