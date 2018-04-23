# Dolos: SDN Honeypot
<pre style="font: 16px/8px monospace;">          `. `'. :;+.,. `   ` :;, '#,  ; ;        
          ,:;;;,  '`.' `,;, `++#:`;';'.;;;.       
         ``';  ;.. '.;.; ;#,;,   '#.+,'::'+;      
          .,:`,,` ..'+'+:'`  ,`, ::..`': :,       
        :.` `.`,:.;#;.::`:, ` ,::,':. ;:;,#:      
       :; : +``;',##,`:; ` ``.,;, ``..`:.`.,.     
       `  . ;`,#,;+:, :` . ;`::` .. .,:,+:,;,     
        ;+:; `.'` `;;``,::.  . ,;: ..,:'. ,':     
          ,'+ '@  `.;  `, . ' :''#   ,,,,#`@@`    
         ..`+;@ :;'```;,.`   :.#+  , ,`` ,+',`    
       `.     `;` .  +'`:    `.'   ````.;.##+;`   
        ;`  .`..  ,;:;,`,,.;;:        .: ##;,#;   
      `. :  ..;..'., :`.##'+           ,+++'+++   
      ,`;` ,+'# ,++;'`#,,,;             '';,'#+   
      `.+: .: ``, `': :                 ,;##+;@   
     ;,  ,.'`  `.': `,,                 .:+'+;`   
     :', +, ',#, ''+:#         ``       `,@+'+    
    `,`,,;;,+`'.;;#++:          `       `:+:#     
    :':.::;'',+#+@++#          .`   `   .;+'#     
      .,,.;+':,+;::+,         `..`  .,`+##+#+     
    , # ';,#; #+@@';`       :'';+;  .:@##++@.     
    .; + ;  ,;' .`:.     ,,'##++#.  ,@@;#@##,     
   ,`  : `.#.;@::.;`   ..,# ,+#. ,` `@+,,:#+      
   ,,...`' + ;+,.';   '..@ + ,#+  .  @;::;;,      
   '; ';   +;#.::+,  '..@ `  .+      :';'#.       
     ..@':''  ,;;:  `...,  .:,#       ',',,,      
      ''';@@:''#':         .;+:       @,...'      
     `#,+',.. @ #`         `,.        ,.,,.'      
    ; ;';;@+,`'@ +                     #.,,+      
   ',.  , ;+@:#`'.                     #,.:#      
  :`;`: @ ,@@   '                ;`    .;,;@      
 `: ''.`   . , , .              ,      :':;@      
 .; .;;;','`;., :.             `,'+@#####:'#      
  +.`': : ',   `;,             . .#  @@@@:''      
   @+`+ ;`.'    .`.           ,.     ;.@#:;;      
     ,;' :++`    ``                :;;;+#;;,      
    ,  ':. '+,,+,               : ##@##@'''`      
     ,,`:';#:'##               ;@@+  .`''+@       
       +#;.' ##' .            `@     ,;##+@       
      ` `, ,;#@',``              `:@@@@@@#@       
        :@`+++@'@ .              '@,   `'#@       
        `. ,.+@++  .             `      :@@       
         ,.+'@,++   .                   ;#+       
         ``#'. #';   ..                `##++      
          `##  @+:    ..             ::'##;:      
             :;#::     `';`,```.   .:+##@+',#;    
             ,    ;     `,@@+';'#####:'++';::'';  
             ,:##,       `.+'@'::;'+@++;;',,,+';'@
             ;#,;.+`      `.,'##+@#'+'':'':,,+:;;;
               ';''#       ``,,,:;''++'';;:.,'::;,
</pre>
<b>What is Dolos?</b>


><p>DOLOS (Dolus) was the personified spirit (<em>daimon</em>) of trickery, cunning deception, craftiness, treachery and guile. He was an apprentice of the Titan <a href="../Titan/TitanPrometheus.html">Prometheus</a> and a companion of the <a href="Pseudologoi.html">Pseudologoi</a> (Lies). His female counterpart was <a href="Apate.html">Apate</a>, the spirit of deception.</p>

[The Theoi Project: Exploring Greek Mythology](http://www.theoi.com/Daimon/Dolos.html)

### Installing Dolos
*	Unzip the file <i>doloshp_install.zip</i>
*	Give executable permissions to the shell script releative to your linux distro
<pre> chmod +x filename.sh </pre>
*       Run the installation script.
<pre> sudo ./filename.sh </pre>
#### Launching Dolos
*         After Dolos has been deployed , you should see an IP address at the end of the installation. Use this address to access the http interface
*         Once opened, attempt to "login" to the interface (<b> note: </b> you will always receive a login failed message, as this honey pot is not connected to any real service
### Testing Dolos
*         To test the database connection, login to the psql database named doloshp
*         Attempt a web-login through the http interface
*         Check to see if there are any new entries within the tables of the database.
