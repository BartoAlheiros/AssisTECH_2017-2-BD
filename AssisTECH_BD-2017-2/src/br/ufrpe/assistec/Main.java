package br.ufrpe.assistec;
<<<<<<< HEAD
	
=======
//teste github	
import java.sql.Connection;

>>>>>>> dbc22005012645874a1c22abfb1fed0b58c296f7
import br.ufrpe.assistec.service.ConnectionFactory;
import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.fxml.FXMLLoader;

//teste edfauno ^^'
public class Main extends Application {
	@Override
	public void start(Stage primaryStage) {
		try {
			BorderPane root = (BorderPane)FXMLLoader.load(getClass().getResource("view/Login.fxml"));
			Scene scene = new Scene(root,360,450);
			scene.getStylesheets().add(getClass().getResource("view/application.css").toExternalForm());
			primaryStage.setScene(scene);
			primaryStage.setTitle("AssisTECH - Login");
			primaryStage.setHeight(450);
			primaryStage.setWidth(360);
			primaryStage.setResizable(false);
			primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
            //iniciando a conexão ao banco
            ConnectionFactory.getConexaoMySQL();

            //exibe status após conexao
            System.out.println(ConnectionFactory.statusConection());
            
            launch(args);
            
            ConnectionFactory.FecharConexao();
          }
}
