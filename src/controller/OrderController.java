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
@WebServlet("/order")
public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public OrderController() {
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
		case "detail":
			RequestDispatcher detailDispatcher = request.getRequestDispatcher("order/detailOrder.jsp");
			detailDispatcher.forward(request, response);
			break;
		}
	}

	private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String id = request.getParameter("id");
		new OrderDAO().delete(id);
		// update dropdown
		OrderDAO.orderMap = OrderDAO.getLoadOrderDTB();
		OrderDAO.setOrderDate = OrderDAO.getLoadDate();
		response.sendRedirect("showOrder.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String func = request.getParameter("function");
		switch (func) {
		case "selectCustomer":
			String customerId = request.getParameter("customerId");
			String orderDate = request.getParameter("orderDate");
			if (customerId != "" && orderDate != "") {
				String orderId = IdGenerator.IDGen("OD");
				new OrderDAO().add(new Order(orderId, orderDate, customerId));
				// update dropdown
				OrderDAO.orderMap = OrderDAO.getLoadOrderDTB();
				OrderDAO.setOrderDate = OrderDAO.getLoadDate();
				//
				request.getSession().setAttribute("addOrderId", orderId);
			}
			response.sendRedirect("order?function=add");
			break;

		case "addItem":
			String orderIdAdd = (String) request.getSession().getAttribute("addOrderId");
			String productId = request.getParameter("productId");
			String quantity = request.getParameter("quantity");
			if (productId != "" && quantity != "") {
				String orderItemId = IdGenerator.IDGen("ODI");
				OrderItem item = new OrderItem(orderItemId, productId, quantity, orderIdAdd);
				new OrderItemDAO().add(item);
			}
			response.sendRedirect("order?function=add");
			break;
		}
	}
}
