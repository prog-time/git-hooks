<?php

namespace App;

class WithErrors
{
    public function broken()
    {
        // Missing return type, undefined variable, etc.
        return $undefined;
    }
}
