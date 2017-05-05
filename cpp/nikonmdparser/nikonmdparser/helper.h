#pragma once

#include <iostream>
#include "nd2ReadSDK.h"
#include "stdafx.h"

std::string wchart_to_string(wchar_t *wc);

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s);
void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s);

