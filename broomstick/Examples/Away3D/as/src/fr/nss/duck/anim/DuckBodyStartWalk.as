package fr.nss.duck.anim {

import away3d.arcane;
import fr.nss.away4.core.animation.NSSSkinAnim;
import flash.geom.Vector3D;
use namespace arcane;
public class DuckBodyStartWalk  extends NSSSkinAnim{

public function DuckBodyStartWalk(){
super("DuckBodyStartWalk");
num_frames(5);
num_joints(36);
c(1);x(-.1);y(70.08);z(87.65);d(.707106);s(.00102662);k(.707107);c(2);x(23.97);y(32.84);z(0);d(.00021493);s(.000772877);k(-.122102);c(3);x(54.18);y(-.05);z(0);d(-.000355956);s(.000513445);k(-.161946);c(4);x(72.05);y(-.02);z(0);d(.000677025);s(-.000446069);k(.112179);c(5);x(28.94);y(-.03);z(0);d(.000699519);s(.000416025);k(-.0149994);c(6);x(38.53);y(-.03);z(0);d(-.000718985);s(-.000423797);k(.152797);c(7);x(39.74);y(.01);z(0);d(-.000605883);s(-.000466742);k(.0342507);c(8);x(21.6);y(4.07);z(35.55);d(.707107);s(.000688394);k(.707107);c(9);x(21.6);y(4.07);z(-36.06);d(.707107);s(.000688394);k(.707107);c(10);x(60.77);y(-4.13);z(16.38);d(-.468744);s(.284199);k(-.823221);c(11);x(41.65);y(.01);z(0);d(-.176974);s(-.327901);k(-.0678793);c(12);x(95.58);y(0);z(0);d(.0376049);s(-.0221026);k(-.861293);c(13);x(142.72);y(-26.67);z(0);d(.00489675);s(.0433437);k(.112154);c(14);x(128.02);y(18.27);z(.08);d(.0412689);s(.0387012);k(.00848016);c(15);x(138.88);y(-3.62);z(-2.11);d(-.211032);s(.155099);k(.017638);c(16);x(52.7);y(100.57);z(-6.08);d(.00134029);s(.00751447);k(-.175705);c(17);x(36.85);y(80.08);z(-15.64);d(-.000115889);s(.000777121);k(.03695);c(18);x(60.77);y(-4.13);z(-16.17);d(.506499);s(-.180903);k(-.814385);c(19);x(41.65);y(.01);z(.01);d(.131946);s(.360188);k(-.221177);c(20);x(95.58);y(0);z(0);d(-.0614339);s(-.00489414);k(-.812017);c(21);x(142.72);y(-26.67);z(.01);d(-.00110045);s(-.0436055);k(.0252046);c(22);x(128.06);y(17.67);z(3.21);d(.0127893);s(-.086212);k(-.146183);c(23);x(138.9);y(-3.64);z(4.1);d(-.0508886);s(-.0210274);k(-.0466459);c(24);x(52.55);y(100.01);z(6.09);d(-.175705);s(.984413);k(.00134234);c(25);x(45.14);y(80.42);z(15.65);d(-.0369496);s(-.999317);k(-.000114916);c(26);x(-31.21);y(-26.04);z(17.85);d(-.16933);s(-.974118);k(-.147948);c(27);x(31.48);y(0);z(0);d(.000417618);s(-.000818931);k(.0597882);c(28);x(40.19);y(.01);z(0);d(.0803249);s(-.0111226);k(-.0128844);c(29);x(16.59);y(63.14);z(0);d(-.000514492);s(.000514492);k(-.707107);c(30);x(-31.21);y(-26.04);z(-17.84);d(.16933);s(.974119);k(-.147945);c(31);x(31.48);y(0);z(.01);d(.000454781);s(.000490059);k(.0597882);c(32);x(40.19);y(.01);z(0);d(-.0803249);s(.0111225);k(-.0128844);c(33);x(16.59);y(63.14);z(0);d(-.000125608);s(-.000125607);k(-.707107);c(34);x(19.31);y(-84.42);z(0);d(.00025244);s(-.000126223);k(.492438);c(35);x(70.33);y(-.04);z(0);d(.000129785);s(.00047124);k(-.169902);e();
c(1);x(-.18);y(70.11);z(89.29);d(-.700467);s(-.0125065);k(-.713448);c(2);d(.000214996);s(.000772275);k(-.122102);c(3);d(-.000353685);s(.00051345);k(-.161946);c(4);d(.000672362);s(-.000449881);k(.113356);c(5);d(-.000116404);s(.000381854);k(-.0138153);c(6);d(.000266005);s(-.000427009);k(.153967);c(7);y(0);d(-.000610085);s(-.00040527);k(.0318836);c(8);s(.000681799);c(9);s(.000681799);c(10);d(-.468744);s(.284199);c(11);d(-.176974);k(-.0678793);c(12);d(.0376049);s(-.0221026);k(-.861293);c(13);z(.01);d(.00489673);s(.0433437);k(.112154);c(14);d(.0412689);s(.0387012);k(.00848012);c(15);d(-.211032);s(.155099);k(.017638);c(16);d(.00134029);s(.00751446);k(-.175705);c(17);d(-.000115674);s(-.000710135);k(.03695);c(18);s(-.180903);k(-.814385);c(19);z(0);d(.131946);s(.360188);k(-.221177);c(20);d(-.0614339);s(-.00489415);k(-.812016);c(21);s(-.0436055);k(.0252046);c(22);d(.0127893);k(-.146183);c(23);d(-.0508886);s(-.0210274);k(-.0466459);c(24);k(.0013423);c(25);d(-.0369496);s(-.999317);k(-.000114853);c(26);d(-.250852);s(-.956734);k(-.147068);c(27);y(.01);d(.00075598);s(-.000204983);k(.0976464);c(28);y(0);d(.0822395);s(-.0200833);k(-.027728);c(29);d(-.000660387);s(.000280446);k(-.718793);c(30);d(.234618);s(.964081);k(-.124222);c(31);d(-.000146102);s(.000427687);k(.395533);c(32);y(0);z(.01);d(-.113942);s(-.00787058);k(-.209719);c(33);d(-.00522176);s(-.0100309);k(-.743562);c(34);d(.000252116);s(-.000126116);k(.492438);c(35);d(-.000712121);s(.000470624);k(-.169902);e();
c(1);x(-.3);y(70.23);z(91.37);d(-.691814);s(-.0280741);k(-.720902);c(2);d(.000215057);s(.000775101);c(3);d(-.000362446);s(.000515232);k(-.161946);c(4);d(.00068037);s(-.000454746);k(.115399);c(5);d(.000487531);s(.000316737);k(-.0117587);c(6);z(.01);d(.00037527);s(-.000430828);k(.155999);c(7);d(-.000609425);s(-.000316827);k(.0277717);c(8);s(.000655252);c(9);s(.000655252);c(10);s(.284199);c(11);z(.01);d(-.176974);s(-.327901);k(-.0678793);c(12);z(.01);d(.0376049);s(-.0221026);k(-.861293);c(13);d(.00489673);s(.0433437);k(.112154);c(14);d(.0412689);s(.0387013);k(.00848016);c(15);d(-.211032);k(.017638);c(16);d(.00134029);s(.00751447);k(-.175705);c(17);d(-.000115357);s(-.000723902);k(.03695);c(18);k(-.814385);c(19);d(.131946);c(20);d(-.0614339);s(-.00489415);c(21);d(-.00110045);k(.0252046);c(22);d(.0127893);s(-.086212);k(-.146183);c(23);d(-.0508886);s(-.0210274);k(-.046646);c(24);k(.00134231);c(25);d(-.0369496);k(-.000114826);c(26);d(.335099);s(.930957);k(.144966);c(27);y(0);d(.000132273);s(.000249992);k(.136118);c(28);y(.01);d(.0841722);s(-.0306257);k(-.0473873);c(29);d(-.000324698);s(.000937553);k(-.748434);c(30);d(.156166);s(.982816);k(-.0980587);c(31);z(0);d(-.00060953);s(-.000482997);k(.459028);c(32);d(-.14063);s(-.0324518);k(-.274782);c(33);d(-.0104281);s(-.0200322);k(-.77783);c(34);d(.000252297);s(-.000126324);k(.492438);c(35);d(.00020729);s(.000470521);k(-.169902);e();
c(1);x(-.47);y(70.43);z(93.1);d(-.682906);s(-.0432686);k(-.727745);c(2);d(.000215126);s(.000767564);c(3);d(-.000355193);s(.000516207);k(-.161946);c(4);d(.000697793);s(-.000453713);k(.11608);c(5);z(.01);d(.000103127);s(.000270067);k(-.0110731);c(6);z(0);d(-.000199022);s(-.000434707);k(.156676);c(7);y(.01);d(-.000610295);s(-.000279545);k(.0264009);c(8);s(.000653605);c(9);s(.000653605);c(11);z(0);d(-.176974);s(-.327901);k(-.0678793);c(12);z(0);d(.0376049);s(-.0221026);c(13);z(0);d(.00489675);s(.0433437);c(14);d(.0412689);s(.0387012);k(.00848014);c(15);d(-.211032);s(.155099);k(.017638);c(16);d(.00134028);s(.00751446);c(17);d(-.000115171);s(-.000703254);k(.03695);c(18);d(.506499);c(19);k(-.221177);c(20);d(-.0614339);s(-.00489414);c(21);d(-.00110045);k(.0252046);c(22);d(.0127893);s(-.086212);c(23);d(-.0508886);s(-.0210274);k(-.0466459);c(24);s(.984413);k(.00134231);c(25);d(-.0369496);k(-.000114481);c(26);d(.414508);s(.898768);k(.14183);c(27);d(.000437151);s(-.000447369);k(.174011);c(28);d(.0843937);s(-.0403121);k(-.0645817);c(29);z(.01);d(-.000340378);s(-.000149886);k(-.783098);c(30);d(.0718928);s(.994845);k(-.0712941);c(31);z(.01);d(-.000161807);s(-.000510821);k(.497407);c(32);z(0);d(-.160287);s(-.0633797);k(-.316479);c(33);z(.01);d(-.0138829);s(-.0266688);k(-.79941);c(34);d(.000250063);s(-.000126053);k(.492438);c(35);z(.01);d(.00045889);s(.000469303);e();
c(1);x(-.65);y(70.65);z(93.7);d(-.675859);s(-.0546704);k(-.732633);c(2);d(.00021515);s(.000771404);k(-.122102);c(3);d(-.000368908);s(.000515138);c(4);z(.01);d(.000656375);s(-.00044803);k(.11317);c(5);z(0);d(.000258889);s(.000316716);k(-.0140023);c(6);z(.01);d(.000115031);s(-.000429836);k(.153782);c(7);y(0);d(-.000618483);s(-.000391177);k(.0322574);c(8);s(.000655252);c(9);s(.000655252);c(10);d(-.468744);s(.284199);c(12);d(.0376049);s(-.0221026);c(13);d(.00489674);s(.0433437);k(.112154);c(14);d(.0412689);s(.0387013);k(.00848015);c(15);s(.155099);k(.017638);c(16);d(.00134029);s(.00751448);k(-.175705);c(17);d(-.000116605);s(-.000703255);k(.03695);c(18);d(.506499);s(-.180903);c(19);d(.131946);s(.360188);k(-.221177);c(20);z(.01);d(-.0614339);s(-.00489413);c(21);d(-.00110044);s(-.0436055);k(.0252046);c(22);d(.0127893);s(-.0862121);k(-.146183);c(23);d(-.0508886);s(-.0210274);k(-.0466459);c(24);d(-.175705);s(.984413);k(.00134232);c(25);d(-.0369496);k(-.000115198);c(26);d(.482457);s(.864477);k(.138211);c(27);d(.000343149);s(-.000619083);k(.210159);c(28);d(.082082);s(-.0464942);k(-.0720483);c(29);z(0);d(.000247755);s(.000100021);k(-.809479);c(30);d(-.0463777);s(.997946);k(-.0440621);c(31);z(0);d(.00026941);s(.000469543);k(.455799);c(32);d(-.177003);s(-.0900267);k(-.306034);c(33);z(0);d(-.0175539);s(-.0304041);k(-.84622);c(34);d(.000251332);s(-.000126018);c(35);d(.000601321);s(.000470505);k(-.169902);e();
c(1);x(-.77);y(70.75);z(84.88);d(-.673019);s(-.0588826);k(-.734472);c(2);d(.000215023);s(.000775115);k(-.122102);c(3);x(54.19);d(-.000340705);s(.000603562);k(-.19389);c(4);z(0);d(.00062961);s(-.000358828);k(.0798676);c(5);z(.01);d(.000930273);s(.000134357);k(-.0474453);c(6);z(0);d(.000218292);s(-.000334045);k(.12064);c(7);z(.01);d(-.000588992);s(-.000313688);k(.131267);c(8);s(.000681594);c(9);s(.000681594);c(11);d(-.176974);c(12);d(.0376048);s(-.0221026);c(13);d(.00489673);s(.0433437);k(.112154);c(14);d(.0412689);s(.0387013);k(.00848015);c(15);d(-.211032);s(.155099);k(.017638);c(16);d(.0013403);s(.00751446);c(17);d(-.000115226);s(.000224742);k(.03695);c(18);d(.506499);s(-.180903);c(19);d(.131946);s(.360188);k(-.221177);c(20);z(0);d(-.0614339);s(-.00489414);c(21);d(-.00110046);s(-.0436055);k(.0252046);c(22);d(.0127893);s(-.086212);k(-.146183);c(23);d(-.0508886);s(-.0210274);k(-.0466459);c(24);d(-.175705);k(.00134231);c(25);k(-.000114371);c(26);d(.533501);s(.834129);k(.134939);c(27);y(.01);d(-.000751073);s(-.000118005);k(.243438);c(28);y(0);z(.01);d(.0769946);s(-.046602);k(-.062526);c(29);d(.000544215);s(-.000725884);k(-.819152);c(30);d(-.057875);s(.997939);k(-.0274887);c(31);d(.000233527);s(-.000279391);k(.5998);c(32);y(.01);z(.01);d(-.170295);s(-.129077);k(-.418995);c(33);d(-.0207981);s(-.0326465);k(-.882139);c(34);d(.00025331);s(-.000126359);k(.492438);c(35);d(-.000243689);s(.000471138);k(-.169902);e();
}
}
}
