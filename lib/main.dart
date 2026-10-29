import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const forest = Color(0xFF145B49), green = Color(0xFF16866B), cream = Color(0xFFFFFCF4), gold = Color(0xFFD3A64B), ink = Color(0xFF173E34);
const copy = <String, Map<String, String>>{
'ar': {'welcome':'مرحبًا بك في قضاء','intro':'رفيقك الهادئ لتنظيم قضاء الصلوات الفائتة','choose':'اختر لغة التطبيق','continue':'المتابعة','home':'الرئيسية','plan':'الخطة اليومية','stats':'الإحصائيات','encouragement':'التشجيع','settings':'الإعدادات','missed':'الصلوات الفائتة','estimate':'حساب الفوائت','done':'تم قضاؤها','remaining':'المتبقي','total':'الإجمالي','progress':'الإنجاز','years':'سنوات الفوائت','save':'حفظ التقدير','daily':'الهدف اليومي','prayers':'صلوات','savePlan':'اعتماد الخطة','log':'تسجيل صلاة تم قضاؤها','motivation':'خطوة ثابتة كل يوم خير من الانقطاع.','verse':'﴿ وَأَقِمِ الصَّلَاةَ لِذِكْرِي ﴾','verseRef':'طه: 14','subtitle':'ابدأ بخطوة صغيرة، واستمر بثبات','language':'اللغة','note':'الحساب تقديري للتنظيم الشخصي، وليس فتوى شرعية.','edit':'تعديل','notifications':'التنبيهات'},
'fr': {'welcome':'Bienvenue sur Qadaa','intro':'Votre compagnon pour organiser les prières à rattraper','choose':'Choisissez la langue','continue':'Continuer','home':'Accueil','plan':'Plan quotidien','stats':'Statistiques','encouragement':'Encouragement','settings':'Paramètres','missed':'Prières à rattraper','estimate':'Estimer les prières','done':'Effectuées','remaining':'Restantes','total':'Total estimé','progress':'Progression','years':'Années estimées','save':'Enregistrer','daily':'Objectif quotidien','prayers':'prières','savePlan':'Valider le plan','log':'Enregistrer une prière effectuée','motivation':'Un petit pas chaque jour vaut mieux que l’abandon.','verse':'« Accomplis la prière pour te souvenir de Moi »','verseRef':'Taha : 14','subtitle':'Commencez doucement, avancez avec constance','language':'Langue','note':'Estimation d’organisation, pas un avis religieux.','edit':'Modifier','notifications':'Notifications'},
'en': {'welcome':'Welcome to Qadaa','intro':'A calm companion to organize missed prayers','choose':'Choose your language','continue':'Continue','home':'Home','plan':'Daily plan','stats':'Statistics','encouragement':'Encouragement','settings':'Settings','missed':'Missed prayers','estimate':'Estimate missed prayers','done':'Completed','remaining':'Remaining','total':'Estimated total','progress':'Progress','years':'Estimated years','save':'Save estimate','daily':'Daily target','prayers':'prayers','savePlan':'Save plan','log':'Log a completed prayer','motivation':'A steady step each day is better than stopping.','verse':'“Establish prayer for My remembrance”','verseRef':'Ta-Ha 20:14','subtitle':'Start small and keep moving forward','language':'Language','note':'An organizational estimate, not a religious ruling.','edit':'Edit','notifications':'Notifications'}
};
String tr(String l, String k) => copy[l]?[k] ?? copy['en']![k]!;

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const QadaaApp()); }

class QadaaApp extends StatefulWidget {
 const QadaaApp({super.key});
 @override State<QadaaApp> createState() => _QadaaAppState();
}
class _QadaaAppState extends State<QadaaApp> {
 String? lang; bool loading = true;
 @override void initState() { super.initState(); SharedPreferences.getInstance().then((p) { if (mounted) setState(() { lang=p.getString('qadaa.language'); loading=false; }); }); }
 Future<void> choose(String v) async { final p=await SharedPreferences.getInstance(); await p.setString('qadaa.language',v); if(mounted) setState(()=>lang=v); }
 @override Widget build(BuildContext context) {
 final l=lang ?? 'ar';
 return MaterialApp(title:'Qadaa | قضاء',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:cream,colorScheme:ColorScheme.fromSeed(seedColor:forest,surface:cream)),
 home: loading ? const Scaffold(backgroundColor:forest,body:Center(child:CircularProgressIndicator(color:gold))) : lang==null ? LanguagePage(onChoose:choose) : Directionality(textDirection:l=='ar'?TextDirection.rtl:TextDirection.ltr,child:Home(language:l,onChoose:choose)));
 }
}

class LanguagePage extends StatefulWidget {
 const LanguagePage({super.key,required this.onChoose}); final Future<void> Function(String) onChoose;
 @override State<LanguagePage> createState()=>_LanguagePageState();
}
class _LanguagePageState extends State<LanguagePage> {
 String selected='ar'; bool saving=false;
 @override Widget build(BuildContext context) {
 final t=(String k)=>tr(selected,k);
 return Scaffold(body:Stack(fit:StackFit.expand,children:[const CustomPaint(painter:Scenery()),SafeArea(child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(children:[
 Container(width:104,height:104,decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(30),border:Border.all(color:gold,width:2)),child:const Icon(Icons.mosque_rounded,color:Color(0xFFFFE8A8),size:60)),
 const SizedBox(height:22),Text(t('welcome'),textAlign:TextAlign.center,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:forest)),
 const SizedBox(height:10),Text(t('intro'),textAlign:TextAlign.center,style:const TextStyle(fontSize:15,height:1.7,color:ink)),const SizedBox(height:28),
 Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:cream,borderRadius:BorderRadius.circular(26),border:Border.all(color:gold)),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 Text(t('choose'),textAlign:TextAlign.center,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:forest)),const SizedBox(height:14),
 for(final item in [('ar','العربية','ع'),('fr','Français','FR'),('en','English','EN')]) Padding(padding:const EdgeInsets.only(bottom:8),child:InkWell(onTap:()=>setState(()=>selected=item.$1),borderRadius:BorderRadius.circular(15),child:Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:selected==item.$1?const Color(0xFFE2EEE4):Colors.white,borderRadius:BorderRadius.circular(15),border:Border.all(color:selected==item.$1?green:const Color(0xFFE6E2D7))),child:Row(children:[CircleAvatar(backgroundColor:forest,child:Text(item.$3,style:const TextStyle(color:gold,fontWeight:FontWeight.bold))),const SizedBox(width:12),Expanded(child:Text(item.$2,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800,color:ink))),Icon(selected==item.$1?Icons.radio_button_checked:Icons.radio_button_off,color:green)])))),
 const SizedBox(height:10),FilledButton(onPressed:saving?null:()async{setState(()=>saving=true);await widget.onChoose(selected);},style:FilledButton.styleFrom(backgroundColor:forest,padding:const EdgeInsets.all(16)),child:saving?const CircularProgressIndicator(color:Colors.white):Text(t('continue'),style:const TextStyle(fontWeight:FontWeight.w800)))
 ]))
 ]))))]));
 }
}

class Home extends StatefulWidget {
 const Home({super.key,required this.language,required this.onChoose}); final String language; final Future<void> Function(String) onChoose;
 @override State<Home> createState()=>_HomeState();
}
class _HomeState extends State<Home> {
 int tab=0,years=5,done=0,target=5; bool loading=true;
 String get l=>widget.language; String t(String k)=>tr(l,k);
 int get total=>years*365*5; int get remaining=>(total-done).clamp(0,total); int get progress=>total==0?0:(done*100/total).round().clamp(0,100).toInt();
 @override void initState(){super.initState();SharedPreferences.getInstance().then((p){if(mounted)setState((){years=p.getInt('years')??5;done=p.getInt('completed')??0;target=p.getInt('dailyTarget')??5;loading=false;});});}
 Future<void> save()async{final p=await SharedPreferences.getInstance();await p.setInt('years',years);await p.setInt('completed',done);await p.setInt('dailyTarget',target);}
 Future<void> edit(bool plan)async{
 int draft=plan?target:years;
 final result=await showModalBottomSheet<int>(context:context,backgroundColor:cream,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(26))),builder:(ctx)=>StatefulBuilder(builder:(ctx,update)=>Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 Text(t(plan?'plan':'estimate'),style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:forest)),const SizedBox(height:16),
 Text((plan?t('daily'):t('years'))+': '+draft.toString(),style:const TextStyle(fontWeight:FontWeight.bold)),Slider(value:draft.toDouble(),min:plan?1:0,max:plan?20:80,divisions:plan?19:80,activeColor:green,onChanged:(v)=>update(()=>draft=v.round())),
 Text(plan?t('subtitle'):(draft*365*5).toString()+' '+t('prayers'),style:const TextStyle(color:ink)),const SizedBox(height:14),
 FilledButton(onPressed:()=>Navigator.pop(ctx,draft),style:FilledButton.styleFrom(backgroundColor:forest),child:Text(t('save')))
 ])))));
 if(result==null)return;setState((){if(plan)target=result;else{years=result;done=done.clamp(0,total).toInt();}});await save();
 }
 Future<void> changeLanguage()async{final value=await showModalBottomSheet<String>(context:context,builder:(ctx)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[for(final x in [('ar','العربية'),('fr','Français'),('en','English')])ListTile(title:Text(x.$2),onTap:()=>Navigator.pop(ctx,x.$1))])));if(value!=null)await widget.onChoose(value);}
 @override Widget build(BuildContext context){
 final pages=<Widget>[
 _home(),
 _simple(t('plan'),Icons.calendar_month,t('daily'),target.toString()+' '+t('prayers'),t('subtitle'),()=>edit(true)),
 _simple(t('stats'),Icons.bar_chart,t('progress'),progress.toString()+'%',t('done')+': '+done.toString()+' · '+t('remaining')+': '+remaining.toString(),()=>edit(false)),
 _simple(t('encouragement'),Icons.volunteer_activism,t('motivation'),t('verse'),t('verseRef'),()=>setState(()=>tab=0)),
 _simple(t('settings'),Icons.settings,t('language'),l.toUpperCase(),t('intro'),changeLanguage)
 ];
 return Scaffold(body:SafeArea(child:loading?const Center(child:CircularProgressIndicator(color:green)):IndexedStack(index:tab,children:pages)),bottomNavigationBar:NavigationBar(height:74,backgroundColor:const Color(0xFFFFFEFA),indicatorColor:const Color(0xFFDCEDE4),selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:[NavigationDestination(icon:const Icon(Icons.home_outlined),label:t('home')),NavigationDestination(icon:const Icon(Icons.calendar_month_outlined),label:t('plan')),NavigationDestination(icon:const Icon(Icons.bar_chart),label:t('stats')),NavigationDestination(icon:const Icon(Icons.volunteer_activism_outlined),label:t('encouragement')),NavigationDestination(icon:const Icon(Icons.settings_outlined),label:t('settings'))]));
 }
 Widget _home()=>CustomScrollView(slivers:[SliverToBoxAdapter(child:SizedBox(height:235,child:ClipRRect(borderRadius:const BorderRadius.vertical(bottom:Radius.circular(28)),child:Stack(fit:StackFit.expand,children:[const CustomPaint(painter:Scenery()),Positioned(left:18,right:18,bottom:22,child:Row(children:[Container(width:66,height:66,decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(20),border:Border.all(color:gold,width:2)),child:const Icon(Icons.mosque,color:gold,size:42)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('قضاء | Qadaa',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900,color:forest)),Text(t('subtitle'),style:const TextStyle(color:ink,fontSize:12))]))]))]))),
 SliverPadding(padding:const EdgeInsets.all(16),sliver:SliverList(delegate:SliverChildListDelegate([
 Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFEAF0E0),borderRadius:BorderRadius.circular(20)),child:Row(children:[const Icon(Icons.auto_awesome,color:green,size:28),const SizedBox(width:10),Expanded(child:Text(t('verse'),style:const TextStyle(fontWeight:FontWeight.w800,color:forest))),Text(t('verseRef'),style:const TextStyle(fontSize:11,color:ink))])),
 const SizedBox(height:14),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:const Color(0xFFE9E5D9))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t('missed'),style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900,color:forest)),const SizedBox(height:14),Row(children:[SizedBox(width:82,height:82,child:Stack(alignment:Alignment.center,children:[SizedBox.expand(child:CircularProgressIndicator(value:progress/100,strokeWidth:8,color:green,backgroundColor:const Color(0xFFE9E9DF))),Text(progress.toString()+'%',style:const TextStyle(fontWeight:FontWeight.w900,color:forest,fontSize:20))])),const SizedBox(width:12),Expanded(child:Column(children:[_metric(t('total'),total.toString()),_metric(t('done'),done.toString()),_metric(t('remaining'),remaining.toString())]))])])),
 const SizedBox(height:12),Row(children:[Expanded(child:_action(t('estimate'),Icons.calculate, const Color(0xFFFAF0DC),gold,()=>edit(false))),const SizedBox(width:10),Expanded(child:_action(t('plan'),Icons.event_available,const Color(0xFFDDF1E7),green,()=>edit(true)))]),
 const SizedBox(height:12),Row(children:[Expanded(child:_action(t('stats'),Icons.insights,const Color(0xFFECE7FA),const Color(0xFF7057C9),()=>setState(()=>tab=2))),const SizedBox(width:10),Expanded(child:_action(t('encouragement'),Icons.volunteer_activism,const Color(0xFFE1F1F8),const Color(0xFF258DB1),()=>setState(()=>tab=3)))]),
 const SizedBox(height:14),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[forest,Color(0xFF247D63)]),borderRadius:BorderRadius.circular(22)),child:Row(children:[const Icon(Icons.spa,color:gold,size:34),const SizedBox(width:12),Expanded(child:Text(t('motivation'),style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w800)))])),
 const SizedBox(height:12),OutlinedButton.icon(onPressed:()async{if(remaining>0){setState(()=>done++);await save();}},icon:const Icon(Icons.check_circle_outline),label:Text(t('log')),style:OutlinedButton.styleFrom(foregroundColor:forest,padding:const EdgeInsets.all(14))),const SizedBox(height:8),Text(t('note'),textAlign:TextAlign.center,style:const TextStyle(fontSize:11,color:Colors.black54))
 ])))]);
 Widget _metric(String a,String b)=>Container(width:double.infinity,margin:const EdgeInsets.only(bottom:6),padding:const EdgeInsets.all(9),decoration:BoxDecoration(color:const Color(0xFFFAFAF4),borderRadius:BorderRadius.circular(12)),child:Row(children:[Expanded(child:Text(a,style:const TextStyle(fontSize:11,color:ink))),Text(b,style:const TextStyle(fontWeight:FontWeight.w900,color:forest))]));
 Widget _action(String label,IconData icon,Color bg,Color accent,VoidCallback fn)=>Material(color:bg,borderRadius:BorderRadius.circular(20),child:InkWell(onTap:fn,borderRadius:BorderRadius.circular(20),child:Container(constraints:const BoxConstraints(minHeight:112),padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[CircleAvatar(backgroundColor:accent,child:Icon(icon,color:Colors.white)),const SizedBox(height:12),Text(label,style:const TextStyle(fontWeight:FontWeight.w900,color:ink)),Align(alignment:AlignmentDirectional.centerEnd,child:Icon(Icons.arrow_forward,color:accent))]))));
 Widget _simple(String title,IconData icon,String heading,String value,String body,VoidCallback fn)=>Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:44,backgroundColor:const Color(0xFFE4EFE5),child:Icon(icon,color:forest,size:44)),const SizedBox(height:20),Text(title,textAlign:TextAlign.center,style:const TextStyle(fontSize:26,fontWeight:FontWeight.w900,color:forest)),const SizedBox(height:16),Text(heading,style:const TextStyle(color:ink)),const SizedBox(height:8),Text(value,textAlign:TextAlign.center,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w900,color:green)),const SizedBox(height:10),Text(body,textAlign:TextAlign.center,style:const TextStyle(height:1.6,color:ink)),const SizedBox(height:22),FilledButton(onPressed:fn,style:FilledButton.styleFrom(backgroundColor:forest),child:Text(t('edit')))])));
}

class Scenery extends CustomPainter {
 const Scenery();
 @override void paint(Canvas c,Size s){
 final r=Offset.zero&s;c.drawRect(r,Paint()..shader=const LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFFF5D9A8),Color(0xFFFFF5DC),Color(0xFFD9E5D1)]).createShader(r));c.drawCircle(Offset(s.width*.52,s.height*.34),s.height*.11,Paint()..color=const Color(0xFFFFF2BE));
 void hill(List<Offset> p,Color color){final path=Path()..moveTo(0,s.height);for(final q in p){path.lineTo(q.dx*s.width,q.dy*s.height);}path.lineTo(s.width,s.height);path.close();c.drawPath(path,Paint()..color=color);}
 hill([const Offset(0,.6),const Offset(.12,.48),const Offset(.23,.56),const Offset(.39,.37),const Offset(.53,.55),const Offset(.67,.42),const Offset(.83,.59),const Offset(1,.46)],const Color(0xFFD8D7B9));hill([const Offset(0,.72),const Offset(.16,.57),const Offset(.29,.67),const Offset(.47,.5),const Offset(.63,.67),const Offset(.79,.54),const Offset(1,.68)],const Color(0xFF9CB7A0));hill([const Offset(0,.84),const Offset(.15,.68),const Offset(.31,.78),const Offset(.49,.65),const Offset(.68,.79),const Offset(.85,.65),const Offset(1,.76)],const Color(0xFF5B8B73));
 final m=Paint()..color=const Color(0xFF245C4A);final x=s.width*.18,y=s.height*.64;c.drawRect(Rect.fromLTWH(x,y+20,76,48),m);c.drawArc(Rect.fromCenter(center:Offset(x+38,y+20),width:45,height:49),3.14159,3.14159,true,m);c.drawRect(Rect.fromLTWH(x-15,y-20,11,88),m);c.drawRect(Rect.fromLTWH(x-18,y-24,17,6),m);c.drawCircle(Offset(x-9.5,y-28),3,Paint()..color=gold);c.drawRect(Rect.fromLTWH(x+14,y+43,13,25),Paint()..color=const Color(0xFFF5E8C9));c.drawRect(Rect.fromLTWH(x+47,y+43,13,25),Paint()..color=const Color(0xFFF5E8C9));
 }
 @override bool shouldRepaint(covariant Scenery oldDelegate)=>false;
}
