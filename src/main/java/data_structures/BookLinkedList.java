package data_structures;

import model.Book;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class BookLinkedList implements Iterable<Book> {
    private Node head;
    private int size;

    private class Node {
        Book data;
        Node next;

        Node(Book data) {
            this.data = data;
            this.next = null;
        }
    }

    public BookLinkedList() {
        head = null;
        size = 0;
    }

    // Add a book to the list
    public void add(Book book) {
        Node newNode = new Node(book);
        if (head == null) {
            head = newNode;
        } else {
            Node current = head;
            while (current.next != null) {
                current = current.next;
            }
            current.next = newNode;
        }
        size++;
    }

    // Get a book by ID
    public Book getById(int id) {
        Node current = head;
        while (current != null) {
            if (current.data.getId() == id) {
                return current.data;
            }
            current = current.next;
        }
        return null;
    }

    // Update a book
    public void update(Book updatedBook) {
        Node current = head;
        while (current != null) {
            if (current.data.getId() == updatedBook.getId()) {
                current.data = updatedBook;
                return;
            }
            current = current.next;
        }
    }

    // Remove a book by ID
    public void remove(int id) {
        if (head == null) return;

        if (head.data.getId() == id) {
            head = head.next;
            size--;
            return;
        }

        Node current = head;
        while (current.next != null) {
            if (current.next.data.getId() == id) {
                current.next = current.next.next;
                size--;
                return;
            }
            current = current.next;
        }
    }

    // Get all books as an array
    public Book[] getAllBooks() {
        Book[] books = new Book[size];
        Node current = head;
        int index = 0;
        while (current != null) {
            books[index++] = current.data;
            current = current.next;
        }
        return books;
    }

    // Get the size of the list
    public int size() {
        return size;
    }

    // Check if the list is empty
    public boolean isEmpty() {
        return size == 0;
    }

    // Iterator implementation
    @Override
    public Iterator<Book> iterator() {
        return new BookIterator();
    }

    private class BookIterator implements Iterator<Book> {
        private Node current = head;

        @Override
        public boolean hasNext() {
            return current != null;
        }

        @Override
        public Book next() {
            if (!hasNext()) {
                throw new NoSuchElementException();
            }
            Book book = current.data;
            current = current.next;
            return book;
        }
    }
} 