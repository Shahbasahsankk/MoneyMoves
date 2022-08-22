
import '../models/transaction_model/transaction_model.dart';

class ChartData{
  final int amount;
  final String categoryName;

  ChartData(this.amount, this.categoryName);
}


chartLogic(List<TransactionModel>list){
int value;
String categoryName;
List visited=[];
List<ChartData> returnData=[];  

  for(var i=0;i<list.length;i++){
    visited.add(0);
  }

  for( var i=0;i<list.length;i++){
    value=list[i].amount.toInt();
    categoryName=list[i].categoryType;
    for(var j=i+1;j<list.length;j++){
      if(categoryName==list[j].categoryType){
        value+=list[j].amount.toInt();
        visited[j]=-1;
      }
    }
    if(visited[i]!=-1){
      returnData.add(ChartData(value, categoryName));
    }
  }
 return returnData;

}
overViewChartLogic(List<TransactionModel>list){
int value;
String transactionName;
List visited=[];
List<ChartData> returnData=[];  

  for(var i=0;i<list.length;i++){
    visited.add(0);
  }

  for( var i=0;i<list.length;i++){
    value=list[i].amount.toInt();
    transactionName=list[i].transactionType;
    for(var j=i+1;j<list.length;j++){
      if(transactionName==list[j].transactionType){
        value+=list[j].amount.toInt();
        visited[j]=-1;
      }
    }
    if(visited[i]!=-1){
      returnData.add(ChartData(value, transactionName));
    }
  }
 return returnData;

}