import 'package:hive/hive.dart';

part 'node.g.dart';

@HiveType(typeId: 0)
class Node{

 @HiveField(0)
 int iD;

 @HiveField(1)
 int yesID;

 @HiveField(2)
 int noID;

 @HiveField(3)
 String question;

 @HiveField(4)
 String extra;

Node(this.iD, this.yesID, this.noID, this.question, this.extra);
}
