package data_structures;

import model.Book;
import java.util.List;

public final class BookQuickSort {
    // Private constructor to prevent instantiation
    private BookQuickSort() {
        throw new AssertionError("Utility class should not be instantiated");
    }

    public static void sortByPrice(List<Book> books, boolean ascending) {
        if (books == null || books.size() <= 1) return;
        quickSortByPrice(books, 0, books.size() - 1, ascending);
    }

    private static void quickSortByPrice(List<Book> books, int low, int high, boolean ascending) {
        if (low < high) {
            int pi = partitionByPrice(books, low, high, ascending);
            quickSortByPrice(books, low, pi - 1, ascending);
            quickSortByPrice(books, pi + 1, high, ascending);
        }
    }
    private static int partitionByPrice(List<Book> books, int low, int high, boolean ascending) {
        double pivot = books.get(high).getPrice();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            boolean shouldSwap = ascending ?
                    books.get(j).getPrice() < pivot :
                    books.get(j).getPrice() > pivot;

            if (shouldSwap) {
                i++;
                swap(books, i, j);
            }
        }
        swap(books, i + 1, high);
        return i + 1;
    }
    public static void sortByRating(List<Book> books, boolean ascending) {
        if (books == null || books.size() <= 1) return;
        quickSortByRating(books, 0, books.size() - 1, ascending);
    }

    private static void quickSortByRating(List<Book> books, int low, int high, boolean ascending) {
        if (low < high) {
            int pi = partitionByRating(books, low, high, ascending);
            quickSortByRating(books, low, pi - 1, ascending);
            quickSortByRating(books, pi + 1, high, ascending);
        }
    }

    private static int partitionByRating(List<Book> books, int low, int high, boolean ascending) {
        double pivot = books.get(high).getRating();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            boolean shouldSwap = ascending ?
                    books.get(j).getRating() < pivot :
                    books.get(j).getRating() > pivot;

            if (shouldSwap) {
                i++;
                swap(books, i, j);
            }
        }
        swap(books, i + 1, high);
        return i + 1;
    }
    private static void swap(List<Book> books, int i, int j) {
        Book temp = books.get(i);
        books.set(i, books.get(j));
        books.set(j, temp);
    }
} 