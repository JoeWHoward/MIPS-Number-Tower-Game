import java.util.Scanner;
import java.util.Random;

/*
    This will create a functioning board using 7 arrays of decremental sizes

 */

public class Main {

    public static void main(String[] args) {

        int[] row7 = new int[7];
        int[] row6 = new int[6];
        int[] row5 = new int[5];
        int[] row4 = new int[4];
        int[] row3 = new int[3];
        int[] row2 = new int[2];
        int[] row1 = new int[1];

        for (int i = 0; i < 7; i++) {  // Iterate through and generate intial random values from 1 to 20
            row7[i] = 1 + (int)(Math.random() * ((20 - 1) + 1));
        }

        updateNums(row6, row7);
        updateNums(row5, row6);
        updateNums(row4, row5);
        updateNums(row3, row4);
        updateNums(row2, row3);
        updateNums(row1, row2);

        printNums(row1);
        printNums(row2);
        printNums(row3);
        printNums(row4);
        printNums(row5);
        printNums(row6);
        printNums(row7);

        int blanks = getNumOfSpaces(row7);

        printNumsWithBlanks(row1, blanks);
        printNumsWithBlanks(row2, blanks);
        printNumsWithBlanks(row3, blanks);
        printNumsWithBlanks(row4, blanks);
        printNumsWithBlanks(row5, blanks);
        printNumsWithBlanks(row6, blanks);
        printNumsWithBlanks(row7, blanks);


    }

    public static void updateNums(int[] array, int[] cmpArray) { //  Iterate through the larger of the two arrays and
        for (int i = 0; i < cmpArray.length - 1; i++) {          //  set the smaller array index value equal to the two
            array[i] = (cmpArray[i] + cmpArray[i+1]);            //  values of the larger array added together
        }
    }

    public static void printNums(int[] array) {                  //  Iterate through array and print numbers
        System.out.println();
        for (int i = 0; i < array.length; i++) {
            System.out.print(" " + array[i]);
        }
    }

    public static void printNumsWithBlanks(int[] array, int blanks) {
        System.out.println();
        for (int i = 0; i < array.length; i++) {                        //  Iterate through the array
            if ((1 + (int)(Math.random() * ((3 - 1) + 1))) % 3 != 0) {  //  If random number isn't == to 3 (2 in 3 odds), print a number
                System.out.print(" " + array[i]);                       //  If random number is 3 (1 in 3 odds), print a blank space
            } else {
                System.out.print("   ");
            }
        }
    }

    public static int getNumOfSpaces(int[] array) {              //  Currently waiting to get used when I think of a way to
        String iString = "";                                     //  use this and make an equally-spaced display of the numbers
        for (int i = 0; i < array.length; i++) {
            iString += " " + array[i];
        }
        return iString.length();
    }
}