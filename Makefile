IN = input
OUT = output
TRANS = transforms
SAXON_JAR ?= ~/saxon/saxon9he.jar

all: nistvscci

nistvscci:
#	this is expecting saxon to be installed in the home directory
	java -jar $(SAXON_JAR)  -o:$(OUT)/nistvscci.html -xsl:$(TRANS)/nistvscci.xsl $(IN)/800-53-controls.xml
	xsltproc  -o $(OUT)/ccilist.html $(TRANS)/cci2html.xsl $(IN)/U_CCI_List.xml
	xsltproc  -o $(OUT)/nist800-53controls.html $(TRANS)/nist800-53.xsl $(IN)/800-53-controls.xml

clean:
	rm $(OUT)/*.html

