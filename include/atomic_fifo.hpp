#include <condition_variable>
#include <list>
#include <mutex>

template <typename T>
class atomic_fifo {
public:
    using value_type = T;
    static_assert(std::is_nothrow_move_constructible<value_type>::value, "sorry, only sane types are supported");

private:
    std::list<value_type> stuff;
    mutable std::mutex mutex;
    std::condition_variable cv;

public:
    template <typename U>
    void push(U&& value)
    {
        std::lock_guard<std::mutex> lock { mutex };
        bool was_empty = stuff.empty();
        stuff.emplace_back(std::forward<U>(value));
        if (was_empty)
            cv.notify_one();
    }

    template <typename... Args>
    void emplace(Args&&... args)
    {
        std::lock_guard<std::mutex> lock { mutex };
        bool was_empty = stuff.empty();
        stuff.emplace_back(std::forward<Args...>(args)...);
        if (was_empty)
            cv.notify_one();
    }

    value_type pop()
    {
        std::unique_lock<std::mutex> lock { mutex };
        if (stuff.empty())
            cv.wait(lock, [this]() { return !stuff.empty(); });

        value_type v { std::move(stuff.front()) };
        stuff.erase(stuff.begin());
        return v;
    }

    bool empty() const
    {
        std::lock_guard<std::mutex> lock { mutex };
        return stuff.empty();
    }
};
