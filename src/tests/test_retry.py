from python_etl.retry import retry


def test_retry_succeeds():
    state = {"n": 0}

    def fn():
        state["n"] += 1
        if state["n"] < 2:
            raise RuntimeError("retry")
        return "ok"

    assert retry(fn, attempts=3, delay=0) == "ok"
