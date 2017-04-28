# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

cimport nd2reader
import settings  # Paths

from libc.stddef cimport wchar_t

def pLIM_FileOpenForRead(filename):
	# Make sure the string is unicode
	filename = unicode(filename)
	cdef Py_ssize_t length
	cdef wchar_t *my_wchars = PyUnicode_AsWideCharString(filename, &length)

	wprintf(my_wchars)
	print("Length:", <long>length)
	print("Null End:", my_wchars[7] == 0)

	print(Lim_FileOpenForRead(my_wchars))

 