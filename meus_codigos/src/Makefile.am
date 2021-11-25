lib_LTLIBRARIES = libmeus_codigos-@API_VERSION@.la

libmeus_codigos_@API_VERSION@_la_SOURCES = \
	meus_codigos-version.h \
	meus_codigos.h \
	$(NULL)

libmeus_codigos_@API_VERSION@_la_CFLAGS = \
	$(MEUS_CODIGOS_CFLAGS) \
	$(WARN_CFLAGS) \
	$(NULL)

libmeus_codigos_@API_VERSION@_la_LIBADD = \
	$(MEUS_CODIGOS_LIBS) \
	$(NULL)

libmeus_codigos_@API_VERSION@_la_LDFLAGS = \
	$(WARN_LDFLAGS) \
	$(NULL)

-include $(top_srcdir)/git.mk
