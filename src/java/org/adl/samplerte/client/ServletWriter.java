/*******************************************************************************
** 
** Filename:  ServletWriter.java
**
** File Description:  This class provides a simple method of posting multiple
** Serialized objects to a Java servlet and getting objects in return. This 
** code was inspired by code samples from the book 'Java Servlet Programming'
** by Jason Hunter and William Crawford (O'Reilly & Associates. 1998).
**    
** Author: ADL Technical Team
**
** Contract Number:
** Company Name: CTC
**
** Module/Package Name:
** Module/Package Description:
**
** Design Issues:
**
** Implementation Issues:
** Known Problems:
** Side Effects:
**
** References: ADL SCORM
**
/*******************************************************************************
**
** Concurrent Technologies Corporation (CTC) grants you ("Licensee") a non-
** exclusive, royalty free, license to use, modify and redistribute this
** software in source and binary code form, provided that i) this copyright
** notice and license appear on all copies of the software; and ii) Licensee
** does not utilize the software in a manner which is disparaging to CTC.
**
** This software is provided "AS IS," without a warranty of any kind.  ALL
** EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING ANY
** IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON-
** INFRINGEMENT, ARE HEREBY EXCLUDED.  CTC AND ITS LICENSORS SHALL NOT BE LIABLE
** FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR
** DISTRIBUTING THE SOFTWARE OR ITS DERIVATIVES.  IN NO EVENT WILL CTC  OR ITS
** LICENSORS BE LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT,
** INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
** CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF THE USE OF
** OR INABILITY TO USE SOFTWARE, EVEN IF CTC  HAS BEEN ADVISED OF THE
** POSSIBILITY OF SUCH DAMAGES.
**
*******************************************************************************/
package org.adl.samplerte.client;

import java.net.*;
import java.io.*;
import java.util.*;
import org.adl.util.debug.DebugIndicator;

//aggiunta per accedere al datamodel

import org.adl.datamodels.*;
import org.adl.datamodels.cmi.*;

public class ServletWriter
{
    private static boolean _Debug = DebugIndicator.ON;

    
    static public String postObjects(URL servlet, Serializable objs[], String sessionid)

    throws Exception
    {
        String newcookie;
        
        URLConnection con;
        if(_Debug) {System.out.println( "In ServletWriter::postObjects() " + servlet );}
        
        try
        {
            if(_Debug) {System.out.println( "Opening HTTP URL connection to servlet." );}
            con = servlet.openConnection();
        }
        catch(Exception e)
        {
            if(_Debug) {System.out.println( "CANNOT OPEN CONNECTION Exception caught In ServletWriter::postObjects()");}
            System.out.println( e.getMessage() );
            e.printStackTrace();
            throw e;
        }

        if(_Debug)
        {   System.out.println( "HTTP connection to servlet is open" );
            System.out.println( "configuring HTTP connection properties" ); }

        String result="";
        String context="";
        
        int numObjects = objs.length;
            
            if(_Debug)
            { System.out.println ( "Num objects: " + numObjects);}

            //Initializing the query string
            result+="functionCalled=";

            for(int x = 0; x < numObjects; x++)
            {
                if ( x == 0 ) 
                {
                        result += (String) objs[0] ;
                }
                
                if(_Debug) {
                    System.out.println(
                    "just wrote a serialized object on output stream... " +
                    objs[x].getClass().getName() );
                    System.out.println(
                    "Value bastard=" +
                    objs[x].toString() );
                    
                    System.out.println(
                    "What is this=" +
                    objs[x].getClass().getFields().toString() );
                }
                                       
                    if (x == 1 ) {
                    
                    //if ever x gets to be == 1 we are SENDING DATA
                        
                    SCODataManager inSCOData = (SCODataManager) objs[1];
                    
                    //debugging method
                    result+="&";
                    result+="data=field=value";
                    context = ",cmi.core.";
                    
                    // Need to get the core object off of the SCO Data Manager
                    // for the current SCO
                    
            if(_Debug)
            {
                    System.out.println("**************************************");
                    System.out.println("CMICORE");
                    System.out.println("**************************************");
            }
                    
                    CMICore lmsCore = inSCOData.getCore();
                    //lmsCore.showData() ;
                    //first CORE non settable (only debug)
                    
            if(_Debug)
            {
                System.out.println("student_id = " + lmsCore.student_id.getValue().toString());
                System.out.println("student_name = " + lmsCore.student_name.getValue().toString());
                    System.out.println("credit = " + lmsCore.credit.getValue().toString());
                    System.out.println("value = " + lmsCore.entry.getValue().toString());
                    System.out.println("lesson_mode = " + lmsCore.lesson_mode.getValue().toString());
                    System.out.println("CMI comments from LMS = "+ inSCOData.comments_from_lms.comments_from_lms.getValue());
            }
                    
            if(_Debug)
            {                   
                    //then CORE settable - lesson advancement 
                    System.out.println("exit = " + lmsCore.exit.getValue().toString());
                    System.out.println("lesson_location = " + lmsCore.lesson_location.getValue().toString());
                    System.out.println("lesson_status = " + lmsCore.lesson_status.getValue().toString());
            }
                    result+=context+"exit="+lmsCore.exit.getValue().toString();
                    result+=context+"lesson_location=" + lmsCore.lesson_location.getValue().toString();
                    result+=context+"lesson_status="+lmsCore.lesson_status.getValue().toString();
                    
                    //then CORE settable - score
                    
            if(_Debug)
            {
                System.out.println("score max = " + lmsCore.score.max.getValue());
                System.out.println("score min = " + lmsCore.score.min.getValue());
                    System.out.println("score raw = " + lmsCore.score.raw.getValue());
            }
                    result+=context+"score_max="+lmsCore.score.max.getValue().toString();
                    result+=context+"score_min="+lmsCore.score.min.getValue().toString();
                    result+=context+"score_raw="+lmsCore.score.raw.getValue().toString();
                    
                    //then CORE settable - session time
                    
            if(_Debug)
            {
                    System.out.println("session_time = " + lmsCore.session_time.getValue().toString());
                    System.out.println("total_time = " + lmsCore.total_time.getValue().toString());
            }
                    result+=context+"session_time="+lmsCore.session_time.getValue().toString();
                    result+=context+"total_time="+lmsCore.total_time.getValue().toString();
                    
                    //then CORE Settable - session comments - nota che comments e lmn_comments non sono 'core' strettamente
           
            if(_Debug)
            {
                System.out.println("CMI comments = "+ inSCOData.comments.comments.getValue());
            }
            result+=context+"comments="+inSCOData.comments.comments.getValue().toString();

                    //then OUT of CORE Settable - but mandatory - non sono core strettamente ma nel nostro datamodel lo sono
           
            if(_Debug)
            {         
                    System.out.println("**************************************");
                    System.out.println("LAUNCH DATA and SUSPEND DATA");
                    System.out.println("**************************************");
                    System.out.println("CMI launch_data =" + inSCOData.launch_data.launch_data.getValue());
                    System.out.println("CMI suspend_data = "+ inSCOData.suspend_data.suspend_data.getValue());
            }
            result+=context+"suspend_data="+inSCOData.suspend_data.suspend_data.getValue().toString();
            
                      
            if(_Debug)
            {
                    System.out.println("************************************************");
                    System.out.println("INTERACTIONS and OBJECTIVES (possibly recursive)");
                    System.out.println("************************************************");
            }       
                    
                    int numobjectives= inSCOData.objectives.objectives.size();
                    System.out.println("CMI objectives [vector size] = " + numobjectives);
             
                    for(int y = 0; y < numobjectives; y++)
                    {
                    
             
            if(_Debug)
            {
                    System.out.println("************************************************");
                    System.out.println("WITHIN OBJECTIVES TREE");
                    System.out.println("************************************************");
            }
                    
                    CMIObjectiveData Obbiettivi = (CMIObjectiveData)inSCOData.objectives.objectives.elementAt(y);
             
            if(_Debug)
            {       
                    System.out.println("CMI objective id = " + Obbiettivi.id.getValue());
                    System.out.println("CMI objective status = " +Obbiettivi.status.getValue());
                    System.out.println("CMI objective score max = " +Obbiettivi.score.max.getValue());
                    System.out.println("CMI objective score min = " +Obbiettivi.score.min.getValue());
                    System.out.println("CMI objective id = " +Obbiettivi.score.raw.getValue());
            }           
                    }
                    
                    CMIInteractions Interactions = inSCOData.getInteractions();
                                        
                    int numinteractions= Interactions.interactions.size();
                    System.out.println("CMI interactions [vector size] = "+ numinteractions);

                    
                    for(int y = 0; y < numinteractions; y++)
                    {
                    
             
            if(_Debug)
            {
                System.out.println("************************************************");
                System.out.println("WITHIN INTERACTIONS TREE");
                System.out.println("************************************************");
            }            
                        // Get the Interaction Data we want
                        CMIInteractionData InteractionData =(CMIInteractionData)Interactions.interactions.elementAt(y);

           
            if(_Debug)
            {
                        System.out.println("CMI interaction id = " +InteractionData.id.getValue());
                        System.out.println("CMI interaction latency  = " +InteractionData.latency.getValue());
                        System.out.println("CMI interaction result = " +InteractionData.result.getValue());
                        System.out.println("CMI interaction student_response = " +InteractionData.student_response.getValue());
                        System.out.println("CMI interactoin time = " +InteractionData.time.getValue());
                        System.out.println("CMI interaction type = " +InteractionData.type.getValue());
                        System.out.println("CMI interaction weigthing = " +InteractionData.weighting.getValue());
            }        
             
                        int numlinkobj = InteractionData.objectives.size();
                        System.out.println("CMI objectives links [enumerator] = "+ numlinkobj);
	
                        
                                    for(int z = 0; z < numlinkobj; z++)
        		            {
                                        Element LinkedObj=(Element) InteractionData.objectives.elementAt(z);
                                        System.out.println("CMI response linked objective "+LinkedObj.getValue());
                                    }

                        
                        
                        int numrisposte = InteractionData.correct_responses.size();
                        System.out.println("CMI interactions correct_responses_patterns [enumerator] = "+ numrisposte);

		                    for(int z = 0; z < numrisposte; z++)
        		            {
			                CMIResponse Risposta=(CMIResponse)InteractionData.correct_responses.elementAt(z);
                    			System.out.println("CMI response pattern"+Risposta.pattern.getValue());
                                    }
                    }
                    
                    System.out.println("**************************************");
                    System.out.println("STUDENT DATA AND PREFS");
                    System.out.println("**************************************");

                    CMIStudentData lmsStudentData=inSCOData.getStudentData();
                    
                    System.out.println("CMI Student_data_mastery_score " + lmsStudentData.mastery_score.getValue().toString() );
                    System.out.println("CMI Student_data_max_time_allowed " + lmsStudentData.max_time_allowed.getValue().toString() );
                    System.out.println("CMI Student_data_time_limit_action " + lmsStudentData.time_limit_action.getValue().toString());
                    
                    CMIStudentPreference lmsSP=inSCOData.getStudentPreference();
                    
                    System.out.println("CMI studentpref audio" + lmsSP.audio.getValue());
                    System.out.println("CMI studentpref language" + lmsSP.language.getValue());
                    System.out.println("CMI studentpref speed" + lmsSP.speed.getValue());
                    System.out.println("CMI studentpref text" + lmsSP.text.getValue());
                   }
            }
       
        System.out.println("RESULT=" + result );
       
        byte[] parameterAsBytes = result.getBytes();
       
        con.setDoOutput( true );
        con.setDoInput( true );        
        con.setRequestProperty("Content=length",String.valueOf(parameterAsBytes.length));
        con.setUseCaches( false );
        con.setRequestProperty( "Content-Type","text/plain" );
        con.setAllowUserInteraction(false);
        String java_version=System.getProperty("java.version");
        System.out.println("java version is: "+java_version);    
              
        if( java_version.startsWith("1.4") || java_version.startsWith("1.3") || java_version.startsWith("1.2") || java_version.startsWith("1.1") ) {
        
        System.out.println("COOKIES JAVA VERSION IS "+java_version);    
        con.setRequestProperty("Cookie", sessionid);
        System.out.println("IL COOKIE SETTATO PER LA SESSIONE e'"+ con.getRequestProperty("Cookie"));
                 
        } else {
        
       System.out.println("NOT SETTING SESSION COOKIES : JAVAWS should do it automatically");
       
        //remove the cookieHandler installed by JavaWebStart (but this compiles with java 5 ?)
        //CookieHandler cookieHandler = java.net.CookieHandler.getDefault();
        //if (cookieHandler != null) {
        //        CookieHandler.setDefault(null);	
        //}	
        
        }
        
        System.out.println("set cookies (as of now) are :");
        System.out.println(con.getRequestProperty("Cookie"));
        
        // Write the arguments as post data
        try
        {
            // Connection opener: this would throw most exceptions (see catches at the very end)
            OutputStream outstream = con.getOutputStream();
            if(_Debug)
            {System.out.println( "Creating new http output stream" );}
            outstream.write(parameterAsBytes);
            if(_Debug)
            {
                System.out.println( "Created new http output stream." );
                System.out.println( "Written command and data to servlet... JUST TO CLOSE" );
            }
         
        try
        {
            if(_Debug){System.out.println( "Prior flushing Object Output Stream." );}
            outstream.flush();
            System.out.println( "Post flushing Object Output Stream." );
            Map headers = con.getHeaderFields();
            System.out.println("Received headers");
            for (Iterator it=headers.entrySet().iterator(); it.hasNext(); ){
                Map.Entry me=(Map.Entry)it.next();
                if((me.getKey()==null)) {
                    
                    //THIS IS THE RESPONSE HEADER, WE SOULD LOOK FOR 500/200/302
                    System.out.println("Server response:"+me.getValue());
                    if(me.getValue().toString().endsWith("OK]")) {
                        System.out.println("Server response is OK");
                    } else {
                        System.out.println("Server error or redirect");
                        return("ERROR:"+me.getValue());
                    }
                  
                } else {
                    if(!(me.getValue()==null)) {
                        if(me.getKey().toString().equals("Set-Cookie")) {
                        System.out.println("WE GOT A NEW COOKIE:");
                        newcookie=me.getValue().toString();
                        //get rid of square brackets
                        newcookie=newcookie.substring(1,newcookie.length()-1);
                        System.out.println("WE GOT A NEW COOKIE:"+newcookie);
                        System.out.println("Cookie parsing... ");
                        //cookie would be [ad_session_id=value; Path=/;Max-Age=1200]
                        String cookietokens[]=newcookie.split(";");
                        int howmany = cookietokens.length;
                        for ( int z = 0 ; z< howmany; z++) {
                            String couple[]=cookietokens[z].split("=");
                            String element=couple[0];
                            String value=couple[1];
                            System.out.println("Element("+element+") Value ("+value+")");
                            if(element.equals("ad_session_id")) {
                                System.out.println("************************");
                                System.out.println("* NEW COOKIE SETTING   *");
                                System.out.println("************************");
                                APIAdapterApplet.cookie=element+"="+value;
                            }
                        }
                    
                    }
                    }
                }
               
                System.out.println(me.getKey()+" = "+me.getValue());
            }
            System.out.println();
            
            //get input stream to read in response from LMS	
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            System.out.println( "3 Flushing Object Output Stream." );
            String aLine = in.readLine();
            result = "";
            while (aLine != null) {
                result += aLine;
                aLine = in.readLine();
            }
                System.out.println( "4 Flushing Object Output Stream." );
            in.close();
                System.out.println( "5 Flushing Object Output Stream." );
            outstream.close();

            String headerField = con.getHeaderField(0); //Gets the status code eg. HTTP/1.0 200 OK	    	    

            if (_Debug) {
                System.out.println("Header field: " + headerField );
                System.out.println("Received value: " + result);
            }
            
            if ( headerField==null )
            {
                if ( result.indexOf("cmi.core") == -1 && result.indexOf("OK")==-1) {
                    throw new Exception(result);
                }
            } else {
                //the following throws exception with opera -- but Opera has null headers....
                if ( headerField.indexOf("200 OK") == -1 ) { //LMS returned an error
                    throw new Exception(result);
                }
            }
	}
        catch(NoRouteToHostException nrh)
        {
            if(_Debug) {
                System.out.println( "(InputStream) Servletwriter Caught NoRouteToHostException");
            }
            nrh.printStackTrace();
            result="ERROR: There is no route to the server.";    
        }
        catch(IOException  ioe)
        {
            if(_Debug)
            {
                System.out.println( "(InputStream) Servletwriter Caught IOException" );
                //APIAdapterApplet.efield.setText("SERVER ERROR while getting");
            }
            ioe.printStackTrace();
            result="ERROR: Communication failure, test connectivity.";
            //throw ioe;
        }
        catch(SecurityException seo)
        {
            if(_Debug) {
                System.out.println( "(InputStream) Servletwriter Caught SecurityException");
            }
            seo.printStackTrace();
            result="ERROR: Your session expired. Log in and reload.";    
        }
            //HERE BEGINS OUTER TRY Catchers (outer is related to outstream usage)
        } catch(NoRouteToHostException nrh)
        {
            if(_Debug) {
                System.out.println( "(OutputStream) Servletwriter Caught NoRouteToHostException");
            }
            nrh.printStackTrace();
            result="ERROR: There is no route to the server.";    
        }  catch(IOException  ioe)
        {
            if(_Debug)
            {
                System.out.println( "(OutputStream) Servletwriter Caught IOException" );
                //APIAdapterApplet.efield.setText("SERVER ERROR while getting");
            }
            ioe.printStackTrace();
            result="ERROR: Communication failure, test connectivity.";
            //throw ioe;
        } catch(SecurityException seo)
        {
            if(_Debug) {
                System.out.println( "(OutputStream) Servletwriter Caught SecurityException");
            }
            seo.printStackTrace();
            result="ERROR: Your session expired. Log in and reload.";    
        }
        
        System.out.println("RISULTATO RICEVUTO DAL SERVER " + result );
        
        return result;
     
    }
}
            
            
            
            /*
            
        }
        
        catch(Exception e)
        {
            if(_Debug)
            {
                System.out.println( "555 Caught Exception when calling out.flush()" );
            }
            e.printStackTrace();
            throw e;
        }

        ObjectInputStream in;

        try
        {
            if(_Debug)
            {
                System.out.println( "Creating new http input stream." );
            }

            in = new ObjectInputStream( con.getInputStream() );
        }
        catch(Exception e)
        {
            if(_Debug)
            {
                System.out.println(
                                  "READING OPEN Exception caught In ServletWriter::postObjects()");
                System.out.println( e.getMessage() );
            }
            e.printStackTrace();
            throw e;
        }

        try
        {
            
            if(_Debug)
            {
                System.out.println( "666 Closing Object Output Stream." );
            }
            out.close();
        }
        catch(IOException  ioe)
        {
            if(_Debug)
            {
                System.out.println( "777 Caught IOException when calling out.close()" );
                System.out.println( ioe.getMessage());
            }
            ioe.printStackTrace();
            throw ioe;
        }
        catch(Exception e)
        {
            if(_Debug)
            {
                System.out.println( "888 Caught Exception when calling out.close()" );
            }
            e.printStackTrace();
            throw e;
        }

        if(_Debug)
        {
           System.out.println("999 about to do four things");
           if ( con == null )
           {
               System.out.println("the connection is gone");
           }
           System.out.println("Content: "+ String.valueOf(con.getContent()));
           System.out.println("did first");
           System.out.println("Content Type: " + con.getContentType());
           System.out.println("did second");
           System.out.println("Content Encoding: " + con.getContentEncoding());
           System.out.println("did third");
           System.out.println( "Ready to create ObjectInputStream object." );
           System.out.println("did last");
        }
        
        System.out.println("AAAAAAAAAAAAAAAAAAARGH");
        
        
        
        
        
        return result;
    }
        
        
        
        
    }     

    

    

    
*/