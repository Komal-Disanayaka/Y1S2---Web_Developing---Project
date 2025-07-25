package service;

//aaha
import jakarta.servlet.ServletContext;
import model.Book;
import model.Order;
import model.Order.OrderBook;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

//aaha
public class OrderService { // Logger setup panrom to log errors
    private static final Logger LOGGER = Logger.getLogger(OrderService.class.getName());
    private static final String ORDERS_FILE = "data" + File.separator + "orders.txt";
    private final String ordersFilePath;
    private final BookService bookService;
    private List<Order> orders;
    // Date format set panrom
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    //aaha
    // Constructor - context-la irundhu path setup panrom
    public OrderService(ServletContext context) {
        String realPath = context.getRealPath("/");
        this.ordersFilePath = realPath + ORDERS_FILE;
        this.bookService = new BookService(context);
        this.orders = new LinkedList<>(); //initialize
        
        // Directory illa-na create panrom
        File ordersFile = new File(ordersFilePath);
        if (!ordersFile.getParentFile().exists()) {
            boolean created = ordersFile.getParentFile().mkdirs();
            if (!created) {
                LOGGER.warning("Failed to create directory: " + ordersFile.getParentFile().getAbsolutePath());
            }
        }
        
        LOGGER.info("Orders file path: " + ordersFilePath);
        loadOrders(); // Load orders when service is initialized
    }
    
    //aaha
    // Pudhu order create panra method
    public Order createOrder(String username, List<OrderBook> items) {
        Order order = new Order(); // object
        order.setOrderNumber(generateOrderNumber());
        order.setUsername(username);
        
        // Create new order items with book information
        List<OrderBook> orderItemsWithBooks = new LinkedList<>();
        double total = 0;
        
        for (OrderBook item : items) {
            Book book = bookService.getBookById(item.getBookId());
            if (book != null) {
                OrderBook newItem = new OrderBook();
                newItem.setBookId(book.getId());
                newItem.setQuantity(item.getQuantity());
                newItem.setBook(book); // Set the book reference
                orderItemsWithBooks.add(newItem);
                total += book.getPrice() * item.getQuantity();
            }
        }
        
        order.setBooks(orderItemsWithBooks); // Order items set panrom
        order.setOrderStatus("Pending");
        order.setDate(new java.util.Date());
        order.setTotal(total);
        
        orders.add(order);
        saveOrders();
        return order;
    }
    
    //aaha
    // Oru user-oda orders fetch panna
    public List<Order> getUserOrders(String username) {
        // Reload orders from file to ensure fresh data
        loadOrders();
        
        List<Order> userOrders = new LinkedList<>();
        for (Order order : orders) {
            if (order.getUsername().equals(username)) {
                userOrders.add(order);
            }
        }
        return userOrders;
    }

    public List<Order> getAllOrders() {
        // Reload orders from file to ensure fresh data
        loadOrders();
        return new LinkedList<>(orders);
    }

    public Order getOrderByNumber(String orderNumber) {
        for (Order order : orders) {
            if (order.getOrderNumber().equals(orderNumber)) {
                return order;
            }
        }
        return null;
    }
    
    //Dinu
    public void updateOrderStatus(String orderNumber, String status) {
        Order order = getOrderByNumber(orderNumber);
        if (order != null) {
            order.setOrderStatus(status);
            saveOrders();
        }
    }

    public void updateOrder(Order updatedOrder) {
        for (int i = 0; i < orders.size(); i++) {
            if (orders.get(i).getOrderNumber().equals(updatedOrder.getOrderNumber())) {
                orders.set(i, updatedOrder);
                saveOrders();
                break;
            }
        }
    }

    public void deleteOrder(String orderNumber) {
        orders.removeIf(order -> order.getOrderNumber().equals(orderNumber));
        saveOrders();
    }

    private String generateOrderNumber() {
        return UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    //aaha
    // Orders file-la irundhu load panna
    private void loadOrders() {
        File file = new File(ordersFilePath);
        if (!file.exists()) {
            LOGGER.info("Orders file does not exist. Creating new file.");
            saveOrders();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            orders.clear();
            String line;
            Order currentOrder = null;
            List<OrderBook> currentItems = new LinkedList<>();

            while ((line = reader.readLine()) != null) {
                try {
                    if (line.startsWith("ORDER:")) {
                        // Save previous order if exists
                        if (currentOrder != null) {
                            currentOrder.setBooks(currentItems);
                            orders.add(currentOrder);
                            currentItems = new LinkedList<>();
                        }
                        
                        // Parse order header
                        String orderData = line.substring(6);
                        String[] orderParts = orderData.split("\\|");
                        
                        // Validate order parts
                        if (orderParts.length < 5) {
                            LOGGER.warning("Invalid order format: " + orderData);
                            continue;
                        }
                        
                        currentOrder = new Order();
                        currentOrder.setOrderNumber(orderParts[0]);
                        currentOrder.setUsername(orderParts[1]);
                        currentOrder.setOrderStatus(orderParts[2]);
                        
                        try {
                            currentOrder.setDate(DATE_FORMAT.parse(orderParts[3]));
                        } catch (Exception e) {
                            LOGGER.warning("Invalid date format: " + orderParts[3] + ". Using current date.");
                            currentOrder.setDate(new java.util.Date());
                        }
                        
                        try {
                            currentOrder.setTotal(Double.parseDouble(orderParts[4]));
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid total format: " + orderParts[4] + ". Using 0.0.");
                            currentOrder.setTotal(0.0);
                        }
                    } else if (line.startsWith("ITEM:") && currentOrder != null) {
                        // Parse order item
                        String itemData = line.substring(5);
                        String[] itemParts = itemData.split("\\|");
                        
                        // Validate item parts
                        if (itemParts.length < 2) {
                            LOGGER.warning("Invalid item format: " + itemData);
                            continue;
                        }
                        
                        OrderBook item = new OrderBook();
                        
                        try {
                            item.setBookId(Integer.parseInt(itemParts[0]));
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid book ID format: " + itemParts[0]);
                            continue;
                        }
                        
                        try {
                            item.setQuantity(Integer.parseInt(itemParts[1]));
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid quantity format: " + itemParts[1] + ". Using 1.");
                            item.setQuantity(1);
                        }
                        
                        Book book = bookService.getBookById(item.getBookId());
                        if (book != null) {
                            item.setBook(book);
                        } else {
                            LOGGER.warning("Book not found for ID: " + item.getBookId());
                        }
                        
                        currentItems.add(item);
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error parsing line: " + line, e);
                    // Continue with next line
                }
            }

            // Add the last order if exists
            if (currentOrder != null) {
                currentOrder.setBooks(currentItems);
                orders.add(currentOrder);
            }
            
            LOGGER.info("Successfully loaded " + orders.size() + " orders");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading orders", e);
        }
    }
    
    //Dinu
    private void saveOrders() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(ordersFilePath))) {
            for (Order order : orders) {
                writer.println("ORDER:" + order.getOrderNumber() + "|" +
                        order.getUsername() + "|" +
                        order.getOrderStatus() + "|" +
                        DATE_FORMAT.format(order.getDate()) + "|" +
                        order.getTotal());

                for (OrderBook item : order.getBooks()) {
                    writer.println("ITEM:" + item.getBookId() + "|" + item.getQuantity());
                }
            }
            LOGGER.info("Successfully saved " + orders.size() + " orders");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving orders", e);
        }
    }
}
