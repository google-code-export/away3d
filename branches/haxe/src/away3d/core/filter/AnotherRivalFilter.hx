package away3d.core.filter;

    import away3d.cameras.*;
    import away3d.containers.*;
    import away3d.core.clip.*;
    import away3d.core.draw.*;
    import away3d.core.render.*;
    
    import flash.utils.*;

    /**
    * Corrects triangle z-sorting
    */
    class AnotherRivalFilter implements IPrimitiveQuadrantFilter {
        
        var maxdelay:Int;
    	
    	var start:Int;
        var check:Int;
    
        var primitives:Array<Dynamic>;
        var pri:DrawPrimitive;
        var turn:Int;
        var leftover:Array<Dynamic>;
        
        var maxZ:Float;
        var minZ:Float;
        var maxdeltaZ:Float;
        
        var rivals:Array<Dynamic>;
        var rival:DrawPrimitive;
        
        var parts:Array<Dynamic>;
        var part:DrawPrimitive;
        
        var ZOrderDeeper:Int ;
        var ZOrderIrrelevant:Int ;
        var ZOrderHigher:Int ;
        var ZOrderSame:Int ;
		
		var q0x:Float;
        var q0y:Float;
        var q1x:Float;
        var q1y:Float;
        var q2x:Float;
        var q2y:Float;
    
        var r0x:Float;
        var r0y:Float;
        var r1x:Float;
        var r1y:Float;
    
        var ql01a:Float;
        var ql01b:Float;
        var ql01c:Float;
        var ql01s:Float;
        var ql01r0:Float;
        var ql01r1:Float;
        
        var ql12a:Float;
        var ql12b:Float;
        var ql12c:Float;
        var ql12s:Float;
        var ql12r0:Float;
        var ql12r1:Float;
        
        var ql20a:Float;
        var ql20b:Float;
        var ql20c:Float;
        var ql20s:Float;
        var ql20r0:Float;
        var ql20r1:Float;
    
        var rla:Float;
        var rlb:Float;
        var rlc:Float;
        var rlq0:Float;
        var rlq1:Float;
        var rlq2:Float;
        
        var q01r:Bool;
        var q12r:Bool;
        var q20r:Bool;
    
        var q01rx:Float;
        var q01ry:Float;
        var q12rx:Float;
        var q12ry:Float;
        var q20rx:Float;
        var q20ry:Float;
        var count:Int;
        var cx:Float;
        var cy:Float;
        
        var q01rd:Float;
        var q12rd:Float;
        var q20rd:Float;
        
        var w0x:Float;
        var w0y:Float;
        var w1x:Float;
        var w1y:Float;
        var w2x:Float;
        var w2y:Float;
    	
        var ql01w0:Float;
        var ql01w1:Float;
        var ql01w2:Float;
        
        var ql12w0:Float;
        var ql12w1:Float;
        var ql12w2:Float;
        
        var ql20w0:Float;
        var ql20w1:Float;
        var ql20w2:Float;
        
        var wl01a:Float;
        var wl01b:Float;
        var wl01c:Float;
        var wl01s:Float;
        var wl01q0:Float;
        var wl01q1:Float;
        var wl01q2:Float;
        
        var wl12a:Float;
        var wl12b:Float;
        var wl12c:Float;
        var wl12s:Float;
        var wl12q0:Float;
        var wl12q1:Float;
        var wl12q2:Float;
        
        var wl20a:Float;
        var wl20b:Float;
        var wl20c:Float;
        var wl20s:Float;
        var wl20q0:Float;
        var wl20q1:Float;
        var wl20q2:Float;
        
        var q01w01:Bool;
        var q12w01:Bool;
        var q20w01:Bool;
        var q01w12:Bool;
        var q12w12:Bool;
        var q20w12:Bool;
        var q01w20:Bool;
        var q12w20:Bool;
        var q20w20:Bool;
        
        var q01w01x:Float;
        var q01w01y:Float;
        var q12w01x:Float;
        var q12w01y:Float;
        var q20w01x:Float;
        var q20w01y:Float;
        var q01w12x:Float;
        var q01w12y:Float;
        var q12w12x:Float;
        var q12w12y:Float;
        var q20w12x:Float;
        var q20w12y:Float;
        var q01w20x:Float;
        var q01w20y:Float;
        var q12w20x:Float;
        var q12w20y:Float;
        var q20w20x:Float;
        var q20w20y:Float;
        
        var q01w01d:Float;
        var q12w01d:Float;
        var q20w01d:Float;
        var q01w12d:Float;
        var q12w12d:Float;
        var q20w12d:Float;
        var q01w20d:Float;
        var q12w20d:Float;
        var q20w20d:Float;
        
        function zconflict(q:DrawPrimitive, w:DrawPrimitive):Int
        {
            if (Std.is( q, DrawTriangle))
            { 
                if (Std.is( w, DrawTriangle))
                    return zconflictTT(cast( q, DrawTriangle), cast( w, DrawTriangle));
                if (Std.is( w, DrawSegment))
                    return zconflictTS(cast( q, DrawTriangle), cast( w, DrawSegment));
                if (Std.is( q, DrawScaledBitmap))
                    return zconflictTB(cast( q, DrawTriangle), cast( w, DrawScaledBitmap));
            }
            else
            if (Std.is( q, DrawSegment))
            {
                if (Std.is( w, DrawTriangle))
                    return -zconflictTS(cast( w, DrawTriangle), cast( q, DrawSegment));
            }
            else
            if (Std.is( q, DrawScaledBitmap))
            {
                if (Std.is( w, DrawTriangle))
                    return -zconflictTB(cast( w, DrawTriangle), cast( q, DrawScaledBitmap));
                if (Std.is( w, DrawScaledBitmap))
                    return zconflictBB(cast( q, DrawScaledBitmap), cast( w, DrawScaledBitmap));
            }
            return ZOrderIrrelevant;
        }
    
        function zconflictBB(q:DrawScaledBitmap, r:DrawScaledBitmap):Int
        {
            if (q.screenZ > r.screenZ)
                return ZOrderDeeper;
            if (q.screenZ < r.screenZ)
                return ZOrderHigher;
    
            return ZOrderSame;
        }

        function zconflictTB(q:DrawTriangle, r:DrawScaledBitmap):Int
        {
            if (q.contains(r.screenvertex.x, r.screenvertex.y))
                return zcompare(q, r, r.screenvertex.x, r.screenvertex.y);
            else
            if (q.contains(r.minX, r.minY))
                return zcompare(q, r, r.minX, r.minY);
            else
            if (q.contains(r.minX, r.maxY))
                return zcompare(q, r, r.minX, r.maxY);
            else
            if (q.contains(r.maxX, r.minY))
                return zcompare(q, r, r.maxX, r.minY);
            else
            if (q.contains(r.maxX, r.maxY))
                return zcompare(q, r, r.maxX, r.maxY);
            else
                return ZOrderIrrelevant;
        }
        
        function zconflictTS(q:DrawTriangle, r:DrawSegment):Int
        {
        /*
            if (q == null)
                return ZOrderIrrelevant;
            if (r == null)
                return ZOrderIrrelevant;
        */
            q0x = q.v0.x;
            q0y = q.v0.y;
            q1x = q.v1.x;
            q1y = q.v1.y;
            q2x = q.v2.x;
            q2y = q.v2.y;
    
            r0x = r.v0.x;
            r0y = r.v0.y;
            r1x = r.v1.x;
            r1y = r.v1.y;
    
            ql01a = q1y - q0y;
            ql01b = q0x - q1x;
            ql01c = -(ql01b*q0y + ql01a*q0x);
            ql01s = ql01a*q2x + ql01b*q2y + ql01c;
            ql01r0 = (ql01a*r0x + ql01b*r0y + ql01c) * ql01s;
            ql01r1 = (ql01a*r1x + ql01b*r1y + ql01c) * ql01s;
    
            if ((ql01r0 <= 0.0001) && (ql01r1 <= 0.0001))
                return ZOrderIrrelevant;
    
            ql12a = q2y - q1y;
            ql12b = q1x - q2x;
            ql12c = -(ql12b*q1y + ql12a*q1x);
            ql12s = ql12a*q0x + ql12b*q0y + ql12c;
            ql12r0 = (ql12a*r0x + ql12b*r0y + ql12c) * ql12s;
            ql12r1 = (ql12a*r1x + ql12b*r1y + ql12c) * ql12s;
    
            if ((ql12r0 <= 0.0001) && (ql12r1 <= 0.0001))
                return ZOrderIrrelevant;
    
            ql20a = q0y - q2y;
            ql20b = q2x - q0x;
            ql20c = -(ql20b*q2y + ql20a*q2x);
            ql20s = ql20a*q1x + ql20b*q1y + ql20c;
            ql20r0 = (ql20a*r0x + ql20b*r0y + ql20c) * ql20s;
            ql20r1 = (ql20a*r1x + ql20b*r1y + ql20c) * ql20s;
    
            if ((ql20r0 <= 0.0001) && (ql20r1 <= 0.0001))
                return ZOrderIrrelevant;
    
            rla = r1y - r0y;
            rlb = r0x - r1x;
            rlc = -(rlb*r0y + rla*r0x);
            rlq0 = (rla*q0x + rlb*q0y + rlc);
            rlq1 = (rla*q1x + rlb*q1y + rlc);
            rlq2 = (rla*q2x + rlb*q2y + rlc);
    
            if ((rlq0*rlq1 >= 0.0001) && (rlq1*rlq2 >= 0.0001) && (rlq2*rlq0 >= 0.0001))
                return ZOrderIrrelevant;
    
            if (((ql01r0 > -0.0001) && (ql12r0 > -0.0001) && (ql20r0 > -0.0001))
             && ((ql01r1 > -0.0001) && (ql12r1 > -0.0001) && (ql20r1 > -0.0001)))
            {
                return zcompare(q, r, (r0x+r1x)/2, (r0y+r1y)/2);
            }
    
            q01r = ((rlq0*rlq1 < 0.0001) && (ql01r0*ql01r1 < 0.0001));
            q12r = ((rlq1*rlq2 < 0.0001) && (ql12r0*ql12r1 < 0.0001));
            q20r = ((rlq2*rlq0 < 0.0001) && (ql20r0*ql20r1 < 0.0001));
    		
            count = 0;
            cx = 0;
            cy = 0;
    
            if ((ql01r0 > 0.0001) && (ql12r0 > 0.0001) && (ql20r0 > 0.0001))
            {
                cx += r0x;
                cy += r0y;
                count += 1;
            }
    
            if ((ql01r1 > 0.0001) && (ql12r1 > 0.0001) && (ql20r1 > 0.0001))
            {
                cx += r1x;
                cy += r1y;
                count += 1;
            }
    
            if (q01r)
            { 
                q01rd = ql01a*rlb - ql01b*rla;
                if (q01rd*q01rd > 0.0001)
                {
                    q01rx = (ql01b*rlc - ql01c*rlb) / q01rd;
                    q01ry = (ql01c*rla - ql01a*rlc) / q01rd;
                    cx += q01rx;
                    cy += q01ry;
                    count += 1;
                }
            }
    
            if (q12r)
            { 
                q12rd = ql12a*rlb - ql12b*rla;
                if (q12rd*q12rd > 0.0001)
                {
                    q12rx = (ql12b*rlc - ql12c*rlb) / q12rd;
                    q12ry = (ql12c*rla - ql12a*rlc) / q12rd;
                    cx += q12rx;
                    cy += q12ry;
                    count += 1;
                }
            }
    
            if (q20r)
            { 
                q20rd = ql20a*rlb - ql20b*rla;
                if (q20rd*q20rd > 0.0001)
                {
                    q20rx = (ql20b*rlc - ql20c*rlb) / q20rd;
                    q20ry = (ql20c*rla - ql20a*rlc) / q20rd;
                    cx += q20rx;
                    cy += q20ry;
                    count += 1;
                }
            }
    
            return zcompare(q, r, cx / count, cy / count);
        }
    

        
        function zconflictTT(q:DrawTriangle, w:DrawTriangle):Int
        {
            q0x = q.v0.x;
            q0y = q.v0.y;
            q1x = q.v1.x;
            q1y = q.v1.y;
            q2x = q.v2.x;
            q2y = q.v2.y;
    
            w0x = w.v0.x;
            w0y = w.v0.y;
            w1x = w.v1.x;
            w1y = w.v1.y;
            w2x = w.v2.x;
            w2y = w.v2.y;
    
            ql01a = q1y - q0y;
            ql01b = q0x - q1x;
            ql01c = -(ql01b*q0y + ql01a*q0x);
            ql01s = ql01a*q2x + ql01b*q2y + ql01c;
            ql01w0 = (ql01a*w0x + ql01b*w0y + ql01c) * ql01s;
            ql01w1 = (ql01a*w1x + ql01b*w1y + ql01c) * ql01s;
            ql01w2 = (ql01a*w2x + ql01b*w2y + ql01c) * ql01s;
    
                if ((ql01w0 <= 0.0001) && (ql01w1 <= 0.0001) && (ql01w2 <= 0.0001))
                    return ZOrderIrrelevant;
    
            ql12a = q2y - q1y;
            ql12b = q1x - q2x;
            ql12c = -(ql12b*q1y + ql12a*q1x);
            ql12s = ql12a*q0x + ql12b*q0y + ql12c;
            ql12w0 = (ql12a*w0x + ql12b*w0y + ql12c) * ql12s;
            ql12w1 = (ql12a*w1x + ql12b*w1y + ql12c) * ql12s;
            ql12w2 = (ql12a*w2x + ql12b*w2y + ql12c) * ql12s;
    
                if ((ql12w0 <= 0.0001) && (ql12w1 <= 0.0001) && (ql12w2 <= 0.0001))
                    return ZOrderIrrelevant;
    
            ql20a = q0y - q2y;
            ql20b = q2x - q0x;
            ql20c = -(ql20b*q2y + ql20a*q2x);
            ql20s = ql20a*q1x + ql20b*q1y + ql20c;
            ql20w0 = (ql20a*w0x + ql20b*w0y + ql20c) * ql20s;
            ql20w1 = (ql20a*w1x + ql20b*w1y + ql20c) * ql20s;
            ql20w2 = (ql20a*w2x + ql20b*w2y + ql20c) * ql20s;
    
                if ((ql20w0 <= 0.0001) && (ql20w1 <= 0.0001) && (ql20w2 <= 0.0001))
                    return ZOrderIrrelevant;
    
            wl01a = w1y - w0y;
            wl01b = w0x - w1x;
            wl01c = -(wl01b*w0y + wl01a*w0x);
            wl01s = wl01a*w2x + wl01b*w2y + wl01c;
            wl01q0 = (wl01a*q0x + wl01b*q0y + wl01c) * wl01s;
            wl01q1 = (wl01a*q1x + wl01b*q1y + wl01c) * wl01s;
            wl01q2 = (wl01a*q2x + wl01b*q2y + wl01c) * wl01s;
    
                if ((wl01q0 <= 0.0001) && (wl01q1 <= 0.0001) && (wl01q2 <= 0.0001))
                    return ZOrderIrrelevant;
    
            wl12a = w2y - w1y;
            wl12b = w1x - w2x;
            wl12c = -(wl12b*w1y + wl12a*w1x);
            wl12s = wl12a*w0x + wl12b*w0y + wl12c;
            wl12q0 = (wl12a*q0x + wl12b*q0y + wl12c) * wl12s;
            wl12q1 = (wl12a*q1x + wl12b*q1y + wl12c) * wl12s;
            wl12q2 = (wl12a*q2x + wl12b*q2y + wl12c) * wl12s;
    
                if ((wl12q0 <= 0.0001) && (wl12q1 <= 0.0001) && (wl12q2 <= 0.0001))
                    return ZOrderIrrelevant;
    
            wl20a = w0y - w2y;
            wl20b = w2x - w0x;
            wl20c = -(wl20b*w2y + wl20a*w2x);
            wl20s = wl20a*w1x + wl20b*w1y + wl20c;
            wl20q0 = (wl20a*q0x + wl20b*q0y + wl20c) * wl20s;
            wl20q1 = (wl20a*q1x + wl20b*q1y + wl20c) * wl20s;
            wl20q2 = (wl20a*q2x + wl20b*q2y + wl20c) * wl20s;
    
                if ((wl20q0 <= 0.0001) && (wl20q1 <= 0.0001) && (wl20q2 <= 0.0001))
                    return ZOrderIrrelevant;
            
                if (((wl01q0*wl01q0 <= 0.0001) || (wl12q0*wl12q0 <= 0.0001) || (wl20q0*wl20q0 <= 0.0001))
                 && ((wl01q1*wl01q1 <= 0.0001) || (wl12q1*wl12q1 <= 0.0001) || (wl20q1*wl20q1 <= 0.0001))
                 && ((wl01q2*wl01q2 <= 0.0001) || (wl12q2*wl12q2 <= 0.0001) || (wl20q2*wl20q2 <= 0.0001)))
                {
                    return zcompare(q, w, (q0x+q1x+q2x)/3, (q0y+q1y+q2y)/3);
                }
            
                if (((ql01w0*ql01w0 <= 0.0001) || (ql12w0*ql12w0 <= 0.0001) || (ql20w0*ql20w0 <= 0.0001))
                 && ((ql01w1*ql01w1 <= 0.0001) || (ql12w1*ql12w1 <= 0.0001) || (ql20w1*ql20w1 <= 0.0001))
                 && ((ql01w2*ql01w2 <= 0.0001) || (ql12w2*ql12w2 <= 0.0001) || (ql20w2*ql20w2 <= 0.0001)))
                {
                    return zcompare(q, w, (w0x+w1x+w2x)/3, (w0y+w1y+w2y)/3);
                }
    
            q01w01 = ((wl01q0*wl01q1 < 0.0001) && (ql01w0*ql01w1 < 0.0001));
            q12w01 = ((wl01q1*wl01q2 < 0.0001) && (ql12w0*ql12w1 < 0.0001));
            q20w01 = ((wl01q2*wl01q0 < 0.0001) && (ql20w0*ql20w1 < 0.0001));
            q01w12 = ((wl12q0*wl12q1 < 0.0001) && (ql01w1*ql01w2 < 0.0001));
            q12w12 = ((wl12q1*wl12q2 < 0.0001) && (ql12w1*ql12w2 < 0.0001));
            q20w12 = ((wl12q2*wl12q0 < 0.0001) && (ql20w1*ql20w2 < 0.0001));
            q01w20 = ((wl20q0*wl20q1 < 0.0001) && (ql01w2*ql01w0 < 0.0001));
            q12w20 = ((wl20q1*wl20q2 < 0.0001) && (ql12w2*ql12w0 < 0.0001));
            q20w20 = ((wl20q2*wl20q0 < 0.0001) && (ql20w2*ql20w0 < 0.0001));
            
            count = 0;
            cx = 0;
            cy = 0;
    
            if ((ql01w0 > 0.0001) && (ql12w0 > 0.0001) && (ql20w0 > 0.0001))
            {
                cx += w0x;
                cy += w0y;
                count += 1;
            }
    
            if ((ql01w1 > 0.0001) && (ql12w1 > 0.0001) && (ql20w1 > 0.0001))
            {
                cx += w1x;
                cy += w1y;
                count += 1;
            }
    
            if ((ql01w2 > 0.0001) && (ql12w2 > 0.0001) && (ql20w2 > 0.0001))
            {
                cx += w2x;
                cy += w2y;
                count += 1;
            }
    
            if ((wl01q0 > 0.0001) && (wl12q0 > 0.0001) && (wl20q0 > 0.0001))
            {
                cx += q0x;
                cy += q0y;
                count += 1;
            }
    
            if ((wl01q1 > 0.0001) && (wl12q1 > 0.0001) && (wl20q1 > 0.0001))
            {
                cx += q1x;
                cy += q1y;
                count += 1;
            }
    
            if ((wl01q2 > 0.0001) && (wl12q2 > 0.0001) && (wl20q2 > 0.0001))
            {
                cx += q2x;
                cy += q2y;
                count += 1;
            }
    
            if (q01w01)
            { 
                q01w01d = ql01a*wl01b - ql01b*wl01a;
                if (q01w01d*q01w01d > 0.0001)
                {
                    q01w01x = (ql01b*wl01c - ql01c*wl01b) / q01w01d;
                    q01w01y = (ql01c*wl01a - ql01a*wl01c) / q01w01d;
                    cx += q01w01x;
                    cy += q01w01y;
                    count += 1;
                }
            }
    
            if (q12w01)
            { 
                q12w01d = ql12a*wl01b - ql12b*wl01a;
                if (q12w01d*q12w01d > 0.0001)
                {
                    q12w01x = (ql12b*wl01c - ql12c*wl01b) / q12w01d;
                    q12w01y = (ql12c*wl01a - ql12a*wl01c) / q12w01d;
                    cx += q12w01x;
                    cy += q12w01y;
                    count += 1;
                }
            }
    
            if (q20w01)
            { 
                q20w01d = ql20a*wl01b - ql20b*wl01a;
                if (q20w01d*q20w01d > 0.0001)
                {
                    q20w01x = (ql20b*wl01c - ql20c*wl01b) / q20w01d;
                    q20w01y = (ql20c*wl01a - ql20a*wl01c) / q20w01d;
                    cx += q20w01x;
                    cy += q20w01y;
                    count += 1;
                }
            }
    
            if (q01w12)
            { 
                q01w12d = ql01a*wl12b - ql01b*wl12a;
                if (q01w12d*q01w12d > 0.0001)
                {
                    q01w12x = (ql01b*wl12c - ql01c*wl12b) / q01w12d;
                    q01w12y = (ql01c*wl12a - ql01a*wl12c) / q01w12d;
                    cx += q01w12x;
                    cy += q01w12y;
                    count += 1;
                }
            }
    
            if (q12w12)
            { 
                q12w12d = ql12a*wl12b - ql12b*wl12a;
                if (q12w12d*q12w12d > 0.0001)
                {
                    q12w12x = (ql12b*wl12c - ql12c*wl12b) / q12w12d;
                    q12w12y = (ql12c*wl12a - ql12a*wl12c) / q12w12d;
                    cx += q12w12x;
                    cy += q12w12y;
                    count += 1;
                }
            }
    
            if (q20w12)
            { 
                q20w12d = ql20a*wl12b - ql20b*wl12a;
                if (q20w12d*q20w12d > 0.0001)
                {
                    q20w12x = (ql20b*wl12c - ql20c*wl12b) / q20w12d;
                    q20w12y = (ql20c*wl12a - ql20a*wl12c) / q20w12d;
                    cx += q20w12x;
                    cy += q20w12y;
                    count += 1;
                }
            }
    
            if (q01w20)
            { 
                q01w20d = ql01a*wl20b - ql01b*wl20a;
                if (q01w20d*q01w20d > 0.0001)
                {
                    q01w20x = (ql01b*wl20c - ql01c*wl20b) / q01w20d;
                    q01w20y = (ql01c*wl20a - ql01a*wl20c) / q01w20d;
                    cx += q01w20x;
                    cy += q01w20y;
                    count += 1;
                }
            }
    
            if (q12w20)
            { 
                q12w20d = ql12a*wl20b - ql12b*wl20a;
                if (q12w20d*q12w20d > 0.0001)
                {
                    q12w20x = (ql12b*wl20c - ql12c*wl20b) / q12w20d;
                    q12w20y = (ql12c*wl20a - ql12a*wl20c) / q12w20d;
                    cx += q12w20x;
                    cy += q12w20y;
                    count += 1;
                }
            }
    
            if (q20w20)
            { 
                q20w20d = ql20a*wl20b - ql20b*wl20a;
                if (q20w20d*q20w20d > 0.0001)
                {
                    q20w20x = (ql20b*wl20c - ql20c*wl20b) / q20w20d;
                    q20w20y = (ql20c*wl20a - ql20a*wl20c) / q20w20d;
                    cx += q20w20x;
                    cy += q20w20y;
                    count += 1;
                }
            }
    
            return zcompare(q, w, cx / count, cy / count);
        }
    	
    	var az:Float;
    	var bz:Float;
    	
        function zcompare(a:DrawPrimitive, b:DrawPrimitive, x:Float, y:Float):Int
        {
            az = a.getZ(x, y);
            bz = b.getZ(x, y);
    
            if (az > bz)
                return ZOrderDeeper;
            if (az < bz)
                return ZOrderHigher;
    
            return ZOrderSame;
        }
        
		/**
		 * Creates a new <code>AnotherRivalFilter</code> object.
		 *
		 * @param	maxdelay	[optional]		The maximum time the filter can take to resolve z-depth before timing out.
		 */
        public function new(?maxdelay:Int = 60000)
        {
            
            ZOrderDeeper = 1;
            ZOrderIrrelevant = 0;
            ZOrderHigher = -1;
            ZOrderSame = 0;
            this.maxdelay = maxdelay;
        }
        
		/**
		 * @inheritDoc
		 */
        public function filter(tree:QuadrantRenderer, scene:Scene3D, camera:Camera3D, clip:Clipping):Void
        {
            start = getTimer();
            check = 0;
    
            primitives = tree.list();
            turn = 0;
            
            while (primitives.length > 0)
            {
                leftover = new Array();
                for (pri in primitives)
                {
                    check++;
                    if (check == 10)
                        if (getTimer() - start > maxdelay)
                            return;
                        else
                            check = 0;
					
                    maxZ = pri.maxZ + 1000;
                    minZ = pri.minZ - 1000;
                    maxdeltaZ = 0;
                    
                    rivals = tree.get(pri);
                    for (rival in rivals)
                    {
                        if (rival == pri)
                            continue;
    
                        switch (zconflict(pri, rival))
                        {
                            case ZOrderIrrelevant:
                                break;
                            case ZOrderDeeper:
                            	if (minZ < rival.screenZ)
                            		minZ = rival.screenZ;
                                break;
                            case ZOrderHigher:
                            	if (maxZ > rival.screenZ)
                            		maxZ = rival.screenZ;
                                break;
                        }
                    }
                    if (maxZ >= pri.screenZ && pri.screenZ >= minZ)
                    {
                        // screenZ still sits between the maxZ and minZ
                    }
                    else if (maxZ >= minZ)
                    {
                    	//screenZ has to be re-calculated for the new maxZ and minZ
                        pri.screenZ = (maxZ + minZ) / 2;
                    }
                    else
                    {
                    	//there is no value for screenZ, triangle is flagged for tesselation
                        if (turn % 3 == 2)
                        {
                            parts = pri.quarter(camera.focus);
                            
                            if (parts == null)
                            	continue;
                            
                                tree.remove(pri);
                                for (part in parts)
                                {
                                    //part.screenZ = pri.screenZ;
                                    if (tree.primitive(part))
	                                    leftover.push(part);
                                }
                        }
                        else
                            leftover.push(pri);
                    }
                }
                primitives = leftover;
                turn += 1;
                if (turn == 20)
                    break;
            }
        }
        
		/**
		 * Used to trace the values of a filter.
		 * 
		 * @return A string representation of the filter object.
		 */
        public function toString():String
        {
            return "AnotherRivalFilter" + ((maxdelay == 60000) ? "" : "("+maxdelay+"ms)");
        }
    }
