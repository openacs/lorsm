/*******************************************************************************
** 
** Filename:  APIAdapterApplet.java
**
** File Description:     
**
** This is a faceless Applet...  no UI 
** 
** This class implements the Sharable Contnet Object (SCO) to Learning 
** Management System (LMS) communication API referenced in the ADL Shareable
** Content Object Reference Model (SCORM) and defined by the Airline Industry
** CBT Committee (AICC).  It is intended to be an example only and as such
** several simplifications have been made.   It is not intended to be a complete
** LMS implementation.  In the interest of time, several shortcuts have been
** taken.  For example, robust error handling along with performance
** optimizatons are left to a later development iteration.
**
** This API is implemented assuming the LMS is a web-based client/server
** application.  This applet runs within the context of the LMS client
** assumed to be HTML and Javascript based running within IE4 or IE5 using
** the Sun Java Runtime Environment Standard Edition version 1.3 OR Netscape
** 4.x using Netscapes JVM.
**
** The LMS Server component is implemented as a Java Servlet
** and handles the persistence of the data model.  At this time, the LMS,
** for the purposes of this example handles only a single user and a single
** lesson.
**
** There are many ways using currently available web technologies that
** an LMS could be implemented to be compliant with the communication mechanisms
** described in the SCORM.  We have chosen this one.
**
** Since the intended usage of this API is via LiveConnect from ECMAScript
** (a.k.a. javascript), we return values from the public LMS functions
** to the caller as String objects.  The ECMAScript caller will see the
** return values as javascript String objects via the magic of LiveConnect.
**
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
**
** Known Problems: 
** 1. In several instances, the parameters to the API functions are
** checked for a value of "null" because the Java Plug-in converts a "" (empty
** string) to null.  This is only a workaround.  The expected parameters
** are "" where stated in SCORM and not "null".
**
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
** OR INABILITY TO USE SOFTWARE, EVEN IF CTC HAS BEEN ADVISED OF THE POSSIBILITY
** OF SUCH DAMAGES.
**
*******************************************************************************/

package org.adl.samplerte.client;

import java.applet.Applet;
//this seems no too ok when hiding frames
//all e. t. commented out
//import java.awt.Graphics;
//import java.awt.*;
import java.io.*;
import java.lang.*;
import java.net.*;
import java.util.*;
import java.util.regex.*;
//these bring out nasty behaviours
//import netscape.javascript.JSObject;
//import netscape.javascript.JSException;
import org.adl.datamodels.*;
import org.adl.datamodels.cmi.*;
import org.adl.samplerte.client.*;
import org.adl.util.debug.DebugIndicator;

public class APIAdapterApplet extends Applet 
{
    
    //public static TextField tfield = new TextField(20);
    //public static TextField efield = new TextField(20);
    
    //public static String LMSInitialize = new String();
   // public String LMSInitialize = "OutsideImplemented";
   // public String LMSGetLastError = "OutsideImplemented";
    
   //This controls display of log messages to the java console
   private static boolean _Debug = DebugIndicator.ON;

   // Handles all LMS Error reporting
   private static LMSErrorManager lmsErrorManager;

   // The current SCOs Data Manager
   private static SCODataManager theSCOData;

   // Handles all Data Model (DM) Error reporting
   private DMErrorManager dmErrorManager;

   private static boolean isLMSInitialized;

   public static boolean areweloading;
   public static boolean arewefinishing = false;
   
//   private JSObject jsroot;
   private String Debug;
   private String DOjs;

   public static String cookie;
   public String LastServerError;
   
   private static String cmiBooleanFalse;
   private static String cmiBooleanTrue;

   private static URL servletURL;
   
   
   /***************************************************************************
   **
   ** Method:  init
   ** Input:   none
   ** Output:  none
   **
   ** Description:
   ** The applet init method
   *****************************************************************************/
   
   public void start() {
       System.out.println("start() applet\n");
       DOjs=this.getParameter("JS");
       Debug=this.getParameter("debug");
       System.out.println("Debug is ="+Debug);
       String cookieName="ad_session_id";
       this.cookie=this.getParameter("cookie");
       if (Debug.equals("false")) {
            _Debug = false;
            DebugIndicator.ON = false;
            System.out.println("debug is (false) "+_Debug);
       } else {
            _Debug = true;
            System.out.println("debug is (true) "+_Debug);
       }

       if ( _Debug ) { System.out.println("Cookies found ="+cookie); }
       //  this is meaningful . if cookie was null we'd better send signals
       //if ( this.cookie!=null ) {this.cookie = "ad_session_id="+URLDecoder.decode(cookie);}
       if ( this.cookie!=null ) {this.cookie = "ad_session_id="+(cookie);}
       System.out.println("cookie is (ending start):"+this.cookie);
       System.out.println("ending start\n");
   }
   
   public void init()
   {
        System.out.println("Version 2007.06.21 init () in applet\n");
   
      // We assume at this point that the user has successfully logged in
      // to the LMS.
        
      //applet has a face if and only if debug is set
      if ( _Debug )
      {
          System.out.println("Before setting interface)");
/*
            this.setBackground(new Color(0x11BB11)); // Set background color to blue.
            this.setForeground(Color.black); // Set foreground color to white.
 
            this.setLayout(new FlowLayout()); // Set flow style.
            //we add the little text field used by debug
            this.add(tfield);
            this.add(efield); efield.setText("");
       
            System.out.println("After setting Interface");
  */
      }


      cmiBooleanFalse = new String("false");
      cmiBooleanTrue = new String("true");


      lmsErrorManager = new LMSErrorManager();
      dmErrorManager = new DMErrorManager();

      this.isLMSInitialized = false;

      URL codebase = this.getCodeBase();
      String host = codebase.getHost();
      String protocol = codebase.getProtocol();
      int port = codebase.getPort();
      String path = codebase.getPath();

      if ( _Debug )
      {
         System.out.println("codebase url is " + codebase.toString());
      }


      
      try
      {

          while(!(path.endsWith("/"))) {
              path=path.substring(0,path.length()-1);
          }
          path=path+"servlet";
          
          if ( port>0 ) {
          this.servletURL =
         new URL(protocol + "://" + host + ":" + port + path );
          } else {
          this.servletURL =
         new URL(protocol + "://" + host + path );              
          }
          
            System.out.println("servlet url is "+ this.servletURL.toString());

         //String session = getCookie("ad_session_id");
         //System.out.println("session is: " + session);
         if ( _Debug ) {
            System.out.println("servlet host "+ host.toString());
            System.out.println("servlet port "+ port);
//            tfield.setText("----inited inited inited");
         }
      }
      catch ( Exception e )
      {
         e.printStackTrace();
         stop();  // we shouldn't proceed if we catch an exception here...
      }

 
   }


   /*****************************************************************************
   **
   ** Method:  getAppletInfo
   ** Input:   none
   ** Output:  String containing the information about the API applet class
   **
   ** Description:
   ** The applet getAppletInfo method
   **
   *****************************************************************************/
   public String getAppletInfo()
   {
      return "RTE API Implementation. Michele Slocovich for SII and .LRN community. Based on:\n" +
             "Sample RTE API Implementation \nAuthor: R. Ball, CTC \n" +
             "Example of one possible LMS API Implementation.";
   }
  
   public void destroy()
   {
       
      if ( _Debug )
      {
 //     this.setBackground(new Color(0xFFFFFF)); // Set background color to blue.
 //     this.setForeground(Color.white); // Set foreground color to white.
      }
      
      System.out.println("begin destroy");
       this.theSCOData=null;
   //    this.tfield=null;
   //    this.efield=null;
      System.out.println("within destroy");
      return ;
   }
   
   public void finalize(){
    //destroy();
     System.out.println("begin finalize");
     System.out.println("within finalize");
     return;
     }

   
   public void stop()
   {
       System.out.println("begin stop");
      System.out.println("within stop");
      return ;
   }
   /*****************************************************************************
   **
   ** Method:  getParameterInfo
   ** Input:   none
   ** Output:  String[][]
   **
   ** Description:
   ** The applet getParameterInfo method
   **
   *****************************************************************************/
   public String[][] getParameterInfo()
   {
      String[][] info = {
            {"None", "", "This applet requires no parameters."}};
      return info;
   }

   /*****************************************************************************
   **
   ** Method:  CheckInitialization
   ** Input:   none
   ** Output:  boolean
   **
   ** Description:
   ** determin
   **
   *****************************************************************************/
   private boolean CheckInitialization()
   {
      if ( isLMSInitialized != true )
      {
         this.lmsErrorManager.SetCurrentErrorCode("301");
      }

      return isLMSInitialized;
   }

   /***************************************************************************
   **
   ** Method:  LMSInitialize(String param)
   ** Input:   String param  - must be null string - reserved for future use
   ** Output:  CMIBoolean  "false" if fails, "true" if succeeds
   **
   ** Description:
   ** The applet init method
   **
   ***************************************************************************/

   public  String LMSInitialize(String param) 
   {
      // This function must be called by a SCO before any other API calls are made.   It can not be called more than once consecutively unless LMSFinish is called.
      if ( _Debug )
      {
      //    tfield.setText("----INITIALIZING---CALL FROM JAVASCRIPT RECEIVED");
         System.out.println("*********************");
         System.out.println("In API::LMSInitialize");
         System.out.println("*********************");
         System.out.println("");
      //    efield.setText("");
      }
      String result = cmiBooleanFalse;  // assume failure
      // Make sure param is empty string "" - as per the API spec
      // Check for "null" is a workaround described in "Known Problems" in the header.
      String tempParm = String.valueOf(param);
      if ( (tempParm.equals("null") || tempParm.equals("")) != true )
      {
         APIAdapterApplet.lmsErrorManager.SetCurrentErrorCode("201");
         return result;
      }
      // Is LMS already initialized?
      if ( APIAdapterApplet.isLMSInitialized == true ) {  
         if ( _Debug ) {
         System.out.println("********************************************");
         System.out.println("LMS seems have been already INITIALIZED");
         System.out.println("********************************************");
      //   tfield.setText("----ALREADY INITED");  
         }
         APIAdapterApplet.lmsErrorManager.SetCurrentErrorCode("101");
         result = cmiBooleanFalse;  // NO success (see return at the end
      }  else {  
         if ( _Debug ) { System.out.println("Trying to get SCO Data from servlet...");   }
         // Build the local (client-side) LMS data model cache by getting the SCODataManager class instances from the LMS Servlet
         ServletProxy servletProxy = new ServletProxy(this.servletURL, this.cookie);
         String DataFromServer =  servletProxy.GetSCOData();
         if(DataFromServer.startsWith("ERROR")) {
                APIAdapterApplet.isLMSInitialized=false;
                APIAdapterApplet.lmsErrorManager.SetCurrentErrorCode("201");
                System.out.println( "Error on server on during communication" );
                this.LastServerError=DataFromServer;     //store this for javascript to know
                result = cmiBooleanFalse;   //no success
                return result;              //tell about no success to caller
         }
         
         if ( _Debug ) { System.out.println("In LMSInitialize : Data obtained from server --> "+DataFromServer); }
         //PARSING RESULT - we must PARSE RESULT AND CALL CORRESPONDING SETTINGS for each couple of values do a LMSSetValue
         try {
            // FIRST WE INITIALIZE AN EMPTY SCODATAMANAGER
            SCODataManager SCOData = new SCODataManager();
            APIAdapterApplet.theSCOData = SCOData;
            System.out.println("In LMSInitialize : CREATED EMPTY DATA" );
            // HERE WE STATE THING IS INITIALIZED - WITHIN CATCH WE SHOULD DE-INITIALIZE NECESSARY FOR SETVALUE TO WORK
            APIAdapterApplet.isLMSInitialized = true;
            System.out.println("In LMSInitialize : now parsing server data" );
            //String[] couples = DataFromServer.split(",");
            Pattern p=Pattern.compile("^([^=]+)=(.*)$");
            DataFromServer=","+DataFromServer;
            String[] couples = DataFromServer.split(",cmi\\.");
            int howmany = couples.length;
            System.out.println("In LMSInitialize, we have : " + howmany + " couples ");
            //note we start from first couple since zeroest is null
            for ( int z = 1 ; z< howmany; z++) {
                String Element="";
                String Value="";
                Matcher m=p.matcher(couples[z]);
                //zeroth split with regex grouping is the whole string
                if(m.find()) {
                  Element=m.group(1);
                  Value=m.group(2);
                } else {
                    System.out.println("PARSE ERROR WITHIN:");
                    System.out.println( "Couple is " + couples[z] );
                }
                //String Element = p.split(couples[z])[1];
                if(z>0) { Element="cmi."+Element; }
		//String Value="";
                //try {Value = p.split(couples[z])[2];} 
		//catch (Exception parser) {Value="";}
                if(_Debug) {   System.out.println( "Couple is " + couples[z] );
                               System.out.println( "setting element " + Element );
                System.out.println( "to value " + Value );  }
                
                if( Value.length()>0 ) {
                APIAdapterApplet.areweloading=true;
                if(_Debug) { System.out.println("LMSSetValue returns " + LMSSetValue(Element,Value));
                        } else { 
                        LMSSetValue(Element,Value);
                        }
                APIAdapterApplet.areweloading=false;
                } else {
                    System.out.println("Received a null value from server: not setting"+Element);
                }
            }
         } catch(Exception parsing) {
                APIAdapterApplet.isLMSInitialized=false;
                APIAdapterApplet.lmsErrorManager.SetCurrentErrorCode("201");
                if(_Debug) {
                System.out.println( "Error while parsing from server" );
                parsing.printStackTrace(); }
                result = cmiBooleanFalse;  //no success
                return result; //tell about no success to caller
         }
         System.out.println("In LMSInitialize : server data parsed" );
         if ( _Debug )
         {  System.out.println("The Core Data for the current SCO contains the following:");
            theSCOData.getCore().showData(); }

         // No errors were detected
         APIAdapterApplet.lmsErrorManager.ClearCurrentErrorCode();
         result = cmiBooleanTrue;  // success
      }

      if ( _Debug )
      {
     //    tfield.setText("----LMSInitialized  OK LMSInitialized");
         System.out.println("");
         System.out.println("********************************************");
         System.out.println("Done Processing LMSInitialize() WITH SUCCESS");
         System.out.println("********************************************");
         System.out.println(" returning "+result);
      }
      return result;
   }

   public String getCookie(String cookieName)
   {
      String cookie=null;
      System.out.println("within getcookie function");
      return cookie;
   }


   /***************************************************************************
   **
   ** Method:  LMSFinish
   ** Input:   none
   ** Output:  none
   **
   ** Description:
   **   Signals completion of communication with LMS
   **
   ***************************************************************************/
   public String LMSFinish(String param)
   {
      if ( _Debug )
      {
         System.out.println("*****************");
         System.out.println("In API::LMSFinish");
         System.out.println("*****************");
         System.out.println("");
     //    tfield.setText("----ENTERED FINISH");
      }
    //  efield.setText("");

      String result = cmiBooleanFalse;  // assume failure

      // Make sure param is empty string "" - as per the API spec
      // Check for "null" is a workaround described in "Known Problems"
      // in the header.
      String tempParm = String.valueOf(param);
      if ( (tempParm.equals("null")) || (tempParm.equals("")) )
      {
         if ( CheckInitialization() == true )
         {
             CMICore lmsCore = this.theSCOData.getCore();

            // Need to add the SCOs Session Time into the running total time
            CMITime totalTime = new CMITime( lmsCore.getTotalTime().getValue() );

            if(_Debug)
            { System.out.println("\tTotal time: " + totalTime.toString()); }
                
            CMITime sessionTime = new CMITime( lmsCore.getSessionTime().getValue() );
                
            if(_Debug)
            { System.out.println("\tSession time: " + sessionTime.toString()); }

            totalTime.add(sessionTime);
            lmsCore.setTotalTime(totalTime.toString());

            if(_Debug)
            { System.out.println("\t\tTotal time: " + totalTime.toString()); }

            // If changes are left uncommitted when LMSFinish
            // is called, the LMS forces an LMSCommit.
            if ( lmsCore.getExit().getValue().equalsIgnoreCase("suspend") )
            { lmsCore.setEntry("resume"); } else { lmsCore.setEntry(""); }

            if ( lmsCore.getLessonStatus().getValue().equalsIgnoreCase("not attempted") )
            { lmsCore.setLessonStatus("incomplete"); }

            this.theSCOData.setCore(lmsCore);

            this.arewefinishing=true;
            System.out.println("About calling LMSCommit from within LMSFinish with finalizing modifier\n");
            result = LMSCommit("");
            this.arewefinishing=false;

            if ( result != cmiBooleanTrue )
            {  //no need to set result since we inherit a false
               if ( _Debug ) { System.out.println("LMSCommit failed causing LMSFinish to fail.");  }
            }
            else
            {
               isLMSInitialized = false;
               result = cmiBooleanTrue;  // successful completion
            }
         }
      }
      else
      {
         this.lmsErrorManager.SetCurrentErrorCode("201");
      }

      if ( _Debug )
      {
         System.out.println("");
         System.out.println("***************************");
         System.out.println("Done Processing LMSFinish()");
         System.out.println("***************************");
         System.out.println(" returning "+result);
     //    tfield.setText("----FINISH Has been processed !");
      }
      if (result==cmiBooleanTrue) {
            //Uninitializing applet after finish
            this.isLMSInitialized = false;
      }
      return result;
   }

   
   public String KeepAlive()
    {
      if ( _Debug )
      {
         System.out.println("*****************");
         System.out.println("In API::KeepAlive");
         System.out.println("*****************");
      }
      String result = cmiBooleanFalse;  // assume failure
      ServletProxy servletProxy = new ServletProxy( this.servletURL, this.cookie);
      String calltoserver = servletProxy.KeepAlive();
   
      if (calltoserver.startsWith("OK")) {
            result=cmiBooleanTrue;
      } else {
            LastServerError=calltoserver;
      }
      
      if ( _Debug )
      {
         System.out.println("***************************");
         System.out.println("Done Processing KeepAlive()");
         System.out.println("***************************");
         System.out.println("RESULT is:"+result);
      }
      return result;
   }

   
   /***************************************************************************
   **
   ** Method:  LMSGetValue(String element)
   ** Input:   String element
   ** Output:  String value of the cmi datamodel element named "element".
   **
   ** Description:
   **   Returns the current value of the cmi datamodel element named "element".
   **
   ***************************************************************************/
   public String LMSGetValue(String element)
   {
      if ( _Debug )
      {
         System.out.println("*******************");
         System.out.println("In API::LMSGetValue");
         System.out.println("*******************");
         System.out.println("");
      }

      if ( CheckInitialization() != true )
      {
         //LMS is not initialized    
         if(_Debug)
         {
            System.out.println("LMS Not Initialized");
         }
         String emptyString = new String("");
         return emptyString;
      }

      if(_Debug)
      {
         System.out.println("Request being processed: LMSGetValue(" + element + ")");
      }

      CMIRequest request = new CMIRequest(element,true);

      if ( _Debug )
      {
         System.out.println("Looking for the element " + request.getRequest() );
      }

      this.lmsErrorManager.ClearCurrentErrorCode();
      this.dmErrorManager.ClearCurrentErrorCode();
      String rtnVal = null;

      DataModelInterface dmInterface = new DataModelInterface();
      rtnVal = dmInterface.processGet(element,theSCOData,dmErrorManager);

      // Set the LMS Error Manager from the DataModel Manager
      lmsErrorManager.SetCurrentErrorCode(dmErrorManager.GetCurrentErrorCode());

      if ( rtnVal != null )
      {
         if ( _Debug )
         {
            System.out.println("LMSGetValue() found!");
            System.out.println("Returning: "+ rtnVal);
         }
      }
      else
      {
         if ( _Debug )
         {
            System.out.println("Found the element, but the value was null");
         }
         rtnVal = new String("");
      }

      if ( _Debug )
      {
         System.out.println("");
         System.out.println("************************************");
         System.out.println("Processing done for API::LMSGetValue");
         System.out.println("************************************");
         System.out.println(" returning "+rtnVal);
      }
      return rtnVal;
   }


   /***************************************************************************
   **
   ** Method:  LMSSetValue(String element, String value)
   ** Input:   String element - cmi data model element (e.g. cmi.core.student_id
   **           String value - value to apply to the data element
   ** Output:  none
   **
   ** Description:
   **   Sets the cmi datamodel element to the specified value
   **
   ***************************************************************************/
   public String LMSSetValue(String element, String value)
   {
      String result = cmiBooleanFalse;

      if ( _Debug )
      {
         System.out.println("*******************");
         System.out.println("In API::LMSSetValue");
         System.out.println("*******************");
         System.out.println("");
      }

      this.lmsErrorManager.ClearCurrentErrorCode();
      this.dmErrorManager.ClearCurrentErrorCode();

      if ( CheckInitialization() != true )
      {
         //LMS is not initialized
         System.out.println("**********************************************************************");
         System.out.println("In API::LMSSetValue ---> LMS IS NOT INITIALIZED ---> NOT SETTING VALUE");
         System.out.println("**********************************************************************");
         System.out.println("The request was: LMSSetValue (element="+element+", value="+value);
          return result;
      }

      String setValue;

      // Check for "null" is a workaround described in "Known Problems"
      // in the header.
      String tempValue = String.valueOf(value);
      if ( tempValue.equals("null") )
      {
         setValue = new String("");
      }
      else
      {
         setValue = tempValue;
      }


      String theRequest = element + "," + setValue;
      if(_Debug)
      {
         System.out.println("Request being processed: LMSSetValue(" + theRequest + ")");
         System.out.println( "Looking for the element " + element );   
      }

      DataModelInterface dmInterface = new DataModelInterface();
      dmInterface.processSet(theRequest,theSCOData,dmErrorManager);

      // Set the LMS Error Manager from the DataModel Manager
      lmsErrorManager.SetCurrentErrorCode(dmErrorManager.GetCurrentErrorCode());
      if ( lmsErrorManager.GetCurrentErrorCode() == "0" )
      {
         result = cmiBooleanTrue; // success
      }

      if ( _Debug )
      {
         System.out.println("");
         System.out.println("************************************");
         System.out.println("Processing done for API::LMSSetValue");
         System.out.println("************************************");
         System.out.println(" returning "+result);
      }
      return result;
   }

   /***************************************************************************
   **
   ** Method:  LMSCommit()
   ** Input:   none
   ** Output:  none
   **
   ** Description:
   **   Applies the SCO data model elements set using LMSSetValue
   **   to LMS data model elements and saves them (on the server).
   **
   ***************************************************************************/
   public String LMSCommit(String param)
   {
      if ( _Debug )
      {
         System.out.println("*************************");
         System.out.println("Processing API::LMSCommit");
         System.out.println("*************************");
//         tfield.setText("during COMMIT to server");
      }

      String result = cmiBooleanFalse; // assume failure
      // Make sure param is empty string "" - as per the API spec
      // Check for "null" is a workaround described in "Known Problems"
      // in the header.
      String tempParm = String.valueOf(param);
      if ( (tempParm.equals("null") || tempParm.equals("")) == true )
      {
         if ( CheckInitialization() != true )
         {  //LMS is not initialized
            LastServerError="LMSFinish without LMSInitialize";
            return result; }
         if ( _Debug )
         {  System.out.println("The SCO Data Manager for the current SCO contains The following:");
            theSCOData.getCore().showData(); }

         ServletProxy servletProxy = new ServletProxy( this.servletURL, this.cookie);
         String servletResult = servletProxy.PutSCOData(this.theSCOData);
         if ( servletResult.equals("OK") != true )
         {
            this.lmsErrorManager.SetCurrentErrorCode("101");
            if ( _Debug )
            {
               System.out.println("Put to Server was NOT successful!");
            }
            //since failure is assumed, no need to set result
            LastServerError=servletResult;
         }
         else
         {
            this.lmsErrorManager.ClearCurrentErrorCode();
            result = cmiBooleanTrue; // successful completion
            if ( _Debug )
            {
               System.out.println("Put to Server succeeded!");
            }
         }
      }
      else
      {
         this.lmsErrorManager.SetCurrentErrorCode("201");
      }

      if ( _Debug )
      {
//         tfield.setText("----LMSCommit LMSCommit LMSCommit");
         System.out.println("");
         System.out.println("**********************************");
         System.out.println("Processing done for API::LMSCommit");
         System.out.println("**********************************");
         System.out.println(" returning "+result);
//         tfield.setText("----COMMITTED OK");
      }
      return result;
   }

   /***************************************************************************
   **
   ** Method:  LMSGetLastError()
   ** Input:   none
   ** Output:  String - error code set by the last API function
   **
   ** Description:
   **   Retrieves the error code set by the most recently executed API function
   **   (Note:  Each API function sets or clears the error code.)
   **
   ***************************************************************************/
  //public class LMSGetLastError{
   public String LMSGetLastError()
   {
      if ( _Debug )
      {
         System.out.println("In API::LMSGetLastError()");
      }
      return APIAdapterApplet.lmsErrorManager.GetCurrentErrorCode();
    }
 //public static String LMSGetLastError="1";
 // public String LMSGetLastError = "InsideImplemented";
 // }

   /***************************************************************************
   **
   ** Method:  LMSGetErrorString( String errorCode)
   ** Input:   String errorCode - the error code to lookup
   ** Output:  String - the text associated with the errorCode
   **
   ** Description:
   **   This function returns the text associated with an error code
   **
   ***************************************************************************/
   public String LMSGetErrorString( String errorCode)
   {
      if ( _Debug )
      {
         System.out.println("In API::LMSGetErrorString()");
      }
      return this.lmsErrorManager.GetErrorDescription(errorCode);
   }

   /***************************************************************************
   **
   ** Method:  LMSGetDiagnostic( String errorCode)
   ** Input:   String errorCode - the error code to lookup
   ** Output:  String - the vendor specific diagnostic text associated with the
   **          errorCode
   **
   ** Description:
   **   This function returns the vendor specific diagnostic text associated
   **  with an error code
   **
   ***************************************************************************/
   public String LMSGetDiagnostic( String errorCode)
   {
      if ( _Debug )
      {
         System.out.println("In API::LMSGetDiagnostic()");
      }
      return this.lmsErrorManager.GetErrorDiagnostic(errorCode); 
   }

}
