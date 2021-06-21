import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

public class tasks {
    public static void main (String[] args) throws SQLException {
        Properties userPass = new Properties ();
        userPass.setProperty ("user","root");
        userPass.setProperty ("password","7878");
        Connection connection = DriverManager.getConnection ("jdbc:mysql://localhost:3306/minions_db",userPass);
/* 1
Write a program that prints on the console all villains’ names and their number of minions.
Get only the villains who have more than 15 minions.
Order them by number of minions in descending order.*/
        firstTask (connection);
/*2.
Get Minion Names
Write a program that prints on the console all minion names and their age for given villain id.
For the output, use the formats given in the examples.*/
        secondTask (connection);
    }

    private static void taskSeparator () {
        System.out.println ("- - - - - - - - - - - - - - - - - -");
    }

    private static void firstTask (Connection connection) throws SQLException {
        System.out.println ("First Task:");
        String task_1 = """
                SELECT\s
                    v.`name`, COUNT(m.`id`) AS `count_minion_army`
                FROM
                    `villains` AS v
                        LEFT JOIN
                    `minions_villains` AS mv ON v.`id` = mv.`villain_id`
                        LEFT JOIN
                    `minions` AS m ON mv.`minion_id` = m.`id`
                GROUP BY v.`id`
                HAVING `count_minion_army`>15
                ORDER BY `count_minion_army` DESC;""";

        PreparedStatement statement = connection.prepareStatement (task_1);
        ResultSet         rs        = statement.executeQuery ();
        while (rs.next ()) {
            System.out.printf ("%s  %s%n",
                    rs.getString (1),rs.getString (2));
        }
        taskSeparator ();
    }

    private static void secondTask (Connection connection) throws SQLException {
        System.out.println ("Second Task:");
        System.out.println ("Enter the desired villain's ID:");
        Scanner scanner   = new Scanner (System.in);
        int     villainId = Integer.parseInt (scanner.nextLine ());
        String task_2 = """
                SELECT\s
                    v.`name`, m.`name`, m.`age`
                FROM
                    `minions` AS m
                        JOIN
                    `minions_villains` AS mv ON m.`id` = mv.`minion_id`
                        JOIN
                    `villains` AS v ON mv.`villain_id` = v.`id`
                WHERE
                    v.`id` = ?
                ORDER BY v.`name`;""";

        PreparedStatement statement = connection.prepareStatement (task_2);
        statement.setInt (1,villainId);
        ResultSet rs = statement.executeQuery ();

        int counter = 0;

        if (!rs.next ()) {
            System.out.println ("No villain with ID 10 exists in the database.");
        } else {
            while (rs.next ()) {
                //used counter to "hack" reading first cursors place without moving it,
                //sure there will be better way described in the exercise :-)
                if (counter == 0) {
                    System.out.printf ("Villain: %s%n",rs.getString (1));
                }
                System.out.printf ("%d. %s  %s%n",
                        ++counter,
                        rs.getString (2),
                        rs.getString (3));
            }
        }
        taskSeparator ();
    }

}
